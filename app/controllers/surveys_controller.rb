class SurveysController < ApplicationController
  include CookieJar
  include SqlOptimizers
  include RelationalLogic
  
  before_action :authenticate_admin!, except: :public_show 
  before_action :params_check, except: [:new, :index]

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
    if @survey.public_link == params[:public_link]
      qns = @survey.survey_questions.order(created_at: :desc)
      if params[:step] && params[:step].to_i > 0
        @survey_question = qns.offset(params[:step].to_i - 1).limit(1).first
      end
      
      @cookie_key = find_or_create_cookie(params[:cookie_key])
      render 'public_show', layout: 'public_survey'
    else
      redirect_to page_404
    end
  end

  def show
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
    
    attrs = params[:survey].permit(:title, :introduction, :status, :thankyou_note)
    @survey.attributes= attrs
    if x = Survey::SurveyStatus.id(params[:displayed_survey_status])
      @survey.status = x
    end

    unless @survey.owner_id
      # Only set owner when the survey is created.
      @survey.owner_id = current_admin.id
      @survey.owner_type = 'Admin'      
    end

    unless request.xhr?
      sqn_ids = params[:survey][:components]&.map { |i| i.to_i} || []
    end
    if (saved = @survey.valid?)
      ActiveRecord::Base.transaction do
        saved &= @survey.save
        unless request.xhr?
          saved &= update_has_many!(@survey, 'SurveyQuestion', 'QuestionAssignment', sqn_ids)
        end
      end
    end
    survey_render_wrap(status: saved, xhr: request.xhr?)
  end
  
  private
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
        if params[:redirect] == 'goto-contained'
          redirect_to survey_questions_url(for_survey: @survey.id)
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
