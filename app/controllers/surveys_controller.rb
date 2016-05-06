class SurveysController < ApplicationController
  include CookieJar
  include SqlOptimizers
  include RelationalLogic
  
  before_action :authenticate_admin!, except: :public_show 
  before_action :params_check, except: :index

  def index
    @surveys = Survey.all
    if request.xhr?
      data = @surveys.map do |s|
        {id: s.id, title: s.title, displayed_survey_status: Survey::SurveyStatus.name(s.status),
         survey_show_url: survey_url(s), survey_edit_url: edit_survey_url(s)}
      end

      render json: ({data: data, allowed_states: Survey.new.status_enum})

    else
      @selected_section = 'surveys'
      # Deliver custom Backbone app js 
      render :index, layout: 'survey_index_layout'
    end
  end

  def public_show
    if request.xhr?
      render_json_payload
    else
      @cookie_key = find_or_create_cookie(params[:cookie_key])
      render 'public_show', layout: 'public_survey'
    end
  end

  def show
    if request.xhr?
      render_json_payload
    end
  end

  def edit
    set_dropdown

    if params[:id] == '0'
      @survey = Survey.new
    else
      create_survey_qn_array
    end
  end
  
  def update
    set_dropdown

    saved = true
    if request.xhr? && (x = Survey::SurveyStatus.id(params[:displayed_survey_status]))
      @survey.update_attributes status: x
    elsif params[:survey]
      attrs = params[:survey]&.permit(:title, :introduction, :status, :thankyou_note)
      @survey.attributes= attrs
      
      unless @survey.owner_id
        # Only set owner when the survey is created.
        @survey.owner_id = current_admin.id
        @survey.owner_type = 'Admin'      
      end

      sqn_ids = params[:survey][:components]&.map { |i| i.to_i} || []
      if (saved = @survey.valid?)
        ActiveRecord::Base.transaction do
          @survey.status ||= 0
          saved &= @survey.save
          saved &= update_has_many!(@survey, 'SurveyQuestion', 'QuestionAssignment', sqn_ids)
        end
      end
    end
    survey_render_wrap(status: saved, xhr: request.xhr?)
  end
  
  private
  def render_json_payload
    render json: (@survey.attributes.slice('id', 'title', 'introduction', 'thankyou_note', 'public_link', 'status').
                   merge({number_of_screens: 2 + @survey.survey_questions.count}))
  end
  
  def create_survey_qn_array
    # id_list elements are numeric, either as Integer or as String
    @survey_qns = @survey.survey_questions.to_a.map do |qn|
      {data: qn, saved: true}
    end
    
    @survey_qns ||= []
    if params[:survey]&.send(:[], :components)
      id_list = params[:survey]&.send(:[], :components)
      @survey_qns += (SurveyQuestion.where('id in (?)', id_list).to_a.map do |qn|
                        @survey_qns.include?({data: qn, saved: true}) ? nil : {data: qn, saved: false}
                      end.compact)
    end
  end
  
  def params_check
    status = true
    status &= params[:id] unless params[:action].to_sym == :public_show

    if status
      case params[:action].to_sym
      when :public_show
        status &= (params[:public_link] && (@survey = Survey.find_by_public_link(params[:public_link])) &&
                   @survey.status == Survey::SurveyStatus::PUBLISHED)
      when :show
        status &= (@survey = Survey.find_by_id params[:id])
      when :edit, :update
        unless params[:id] == '0'
          status &= (@survey = Survey.find_by_id params[:id])
        end
      end
    end
    
    if params[:id] == '0'
      @survey = Survey.new
    end
    if !status
      redirect_to page_404
    end

    status
  end
  
  def set_dropdown
    @survey_status_select = Survey::SurveyStatus.option_array
    @select_default = @survey.status
  end

  def survey_render_wrap(status:, xhr:)
    if status
      if xhr
        render json: @survey, status: 201
      else
        flash[:alert] = nil
        case params[:redirect]
        when 'goto-contained'
          redirect_to survey_questions_url(add_to_survey: @survey.id)
        when 'edit'
          redirect_to edit_survey_url(id: @survey.id)
        else
          redirect_to survey_url(@survey)
        end
      end
    else
      if xhr
        render json: @survey, status: 422
      else
        flash[:alert] = t(:resource_creation_failure, resource_name: 'Survey')
        create_survey_qn_array
        render :edit, status: 422
      end
    end
  end
end
