class SurveysController < ApplicationController
  include CookieJar
  include SqlOptimizers
  include RelationalLogic

  before_action :set_menubar_variables
  before_action :authenticate_admin!, except: :public_show 
  before_action :params_check, except: :index

  def new
    set_dropdown
    @level2_menu = :create_survey
  end
  
  def index
    @surveys = Survey.all
    if request.xhr?
      data = @surveys.map do |s|
        {id: s.id, title: s.title, displayed_survey_status: Survey::SurveyStatus.name(s.status),
         survey_show_url: survey_url(s), survey_edit_url: edit_survey_url(s)}
      end

      render json: ({data: data, allowed_states: Survey.new.status_enum})

    else
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
    create_survey_qn_array
  end
  
  def update
    set_dropdown

    saved = true
    if request.xhr? && (x = Survey::SurveyStatus.id(params[:displayed_survey_status]))
      @survey.update_attributes status: x
    elsif params[:survey]
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
  alias :create :update
  
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

    if status
      case params[:action].to_sym
      when :new
        @survey = Survey.new
      when :public_show
        status &= (params[:public_link] && (@survey = Survey.find_by_public_link(params[:public_link])) &&
                   @survey.status == Survey::SurveyStatus::PUBLISHED)
      when :show, :edit
        status &= (@survey = Survey.find_by_id params[:id])
      when :create
        status &= params[:survey]
        if status
          @survey = Survey.new 
          attrs = params[:survey]&.permit(:title, :introduction, :status, :thankyou_note)
          @survey.attributes= attrs
        end
      when :update
        status &= params[:survey]
        status &= (@survey = Survey.find_by_id params[:id])
        if status
          attrs = params[:survey]&.permit(:title, :introduction, :status, :thankyou_note)
          @survey.attributes= attrs
        end
      end
    end
    
    if !status
      redirect_to page_404
    end

    status
  end

  def set_menubar_variables
    @navbar_active_section = :surveys
  end
  
  def set_dropdown
    @survey_status_select = Survey::SurveyStatus.option_array
    @select_default = @survey.status || 0
  end

  def survey_render_wrap(status:, xhr:)
    if status
      if xhr
        render json: @survey, status: 201
      else
        flash[:alert] = nil
        redirect_to survey_url(@survey)
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
