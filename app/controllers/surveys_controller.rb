class SurveysController < ApplicationController
  include CookieJar
  include SqlOptimizers
  include RelationalLogic

  before_action :set_menubar_variables
  before_action :authenticate_request, except: :public_show 
  before_action :params_check, except: :index

  def new
    set_dropdown
    @level2_menu = :create_survey
  end
  
  def index
    @surveys = Survey.all.order(created_at: :desc)
    if request.xhr?
      data = @surveys.map do |s|
        {id: s.id, title: s.title, status: s.status, public_link: (s.published? ? s.public_link: ''),
         has_answers: s.individual_answers.count > 0,
         survey_show_url: survey_url(s), survey_edit_url: edit_survey_url(s)}.merge({report: report_hash(s)})
      end

      render json: data
    else
      render :index
    end
  end

  def public_show
    if request.xhr?
      render_json_payload
    else
      cookie_key = find_or_create_cookie params[:cookie_key]
      if cookie_key.new? || !(Response.find_by_respondent_id(cookie_key.respondent_id)&.closed?)
        @cookie_key = cookie_key.key
        render 'public_show', layout: 'public_survey'
      else
        # This cookie has been used to complete this survey - don't let the user enter the survey again.
        render 'public_show_closed', layout: 'public_survey'
      end
    end
  end

  def show
    if request.xhr?
      render_json_payload
    end
  end

  def edit
    @level2_menu = :create_survey
    @report_list = report_hash(@survey).merge({title: @survey.title})
    @full_public_link = "#{request.protocol}#{request.host}"
    @full_public_link += request.port == 80 ? '' : ":#{request.port}"
    @full_public_link += "/surveys/public_show/#{@survey.public_link}"
    set_dropdown
  end
  
  def update
    set_dropdown

    saved = true
    if request.xhr?
      if Survey::SurveyStatus.valid?(params[:status])
        @survey.update_attributes status: params[:status]
      end
    else 
      if @survey.nil?
        # This implies we are in the create action
        @survey = Survey.new 
        # Only set owner and draft status when the survey is created.
        @survey.status = 0        
        @survey.owner_id = current_admin.id
        @survey.owner_type = 'Admin'      
      end

      attrs = params[:survey]&.permit(:title, :introduction, :status, :thankyou_note)
      @survey.attributes= attrs
    end
    
    if (saved = @survey.valid?)
      if params[:survey_details].present? and (deets = JSON.parse(params[:survey_details])).is_a?(Hash)
        sqn_ids = deets.with_indifferent_access[:details].sort_by { |i| i['component_rank']}.map { |hash| hash['id'].to_i}
      else
        sqn_ids = []
      end
      
      ActiveRecord::Base.transaction do
        saved &= @survey.save
        saved &= update_has_many!(@survey, 'SurveyQuestion', 'QuestionAssignment', sqn_ids, should_delete: true)
      end
    end
    
    survey_render_wrap(status: saved, xhr: request.xhr?)
  end
  alias :create :update


  def report
    if @survey = Survey.find_by_id(params[:id])
      @report_list = report_hash(@survey).merge({title: @survey.title})
      template_name = (params[:full] ? :full_report : :report)

      render "surveys/#{template_name}", layout: 'survey_report'
    else
      redirect_to surveys_path
    end
  end

  private
  def report_hash(s)
    params[:full] ? s.full_report_hash : s.report_hash
  end
  
  def render_json_payload
    # One screen for each qn + intro + summary
    json = (@survey.attributes.slice('id', 'title', 'introduction', 'thankyou_note', 'public_link', 'status').
             merge({number_of_screens: 2 + @survey.survey_questions.count}))    
    render json: json
  end
  
  def params_check
    status = true

    if status
      case params[:action].to_sym
      when :new
        @survey = Survey.new
        # For use in view helpers
        @form_object = @survey
      when :public_show
        status &= params[:public_link] && (@survey = Survey.find_by_public_link(params[:public_link])) &&
                  (current_admin || @survey.status == Survey::SurveyStatus::PUBLISHED)
      when :show, :edit
        status &= (@survey = Survey.find_by_id params[:id])
        # For use in view helpers
        @form_object = @survey
      when :create
        status &= params[:survey]
      when :update
        status &= params[:survey]
        status &= (@survey = Survey.find_by_id params[:id])
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
    @select_default = @survey&.status || 0
    @show_list_keys = {0 => 'Draft', 1 => 'Published', 2 => 'Closed'}    
  end

  def survey_render_wrap(status:, xhr:)
    if status
      if xhr
        render json: @survey, status: 201
      else
        flash[:alert] = nil
        redirect_to surveys_url
      end
    else
      if xhr
        render json: @survey, status: 422
      else
        flash.now[:alert] = t(:resource_creation_failure, resource_name: 'Survey')
        render :new, status: 422
      end
    end
  end

  def authenticate_request
    # Special method to allow hand-rolled oAuth-like querying to test out the reporting interface
    if request.xhr? && params[:token].present? &&
       (adm = Admin.find_by_auth_token(params[:token]))
      @current_admin = adm
      return true
    else
      return authenticate_admin!
    end
  end
end
