class SurveysController < ApplicationController
  before_action :admin_signed_in?, except: :show 
  before_action :params_check

  def index
    @surveys = Survey.all
  end
  
  def show
    # Admins don't need to show token
    permitted = false

    if current_admin
      permitted = true
    else
      # Not admin - require token
      if params[:token] and @survey.token == params[:token]
        permitted = true
      end
    end

    permitted ? (render 'show') : (raise ActionController::RoutingError.new(''))
  end

  def edit
    @payload = {step_command: params[:step_command]}
    case params[:step_command].to_sym
    when :init
      render 'new'
    else
      render 'edit'
    end
  end

  def update
    success = false
    @payload = {}
    @payload[:step_command] = current_step = params[:step_command].to_sym

    case current_step
    when :init
      @survey = Survey.new(title: params[:title], status: Survey::SurveyStatus::DRAFT)
      if @survey.valid?
        @survey.save
        success = true
      end
    when :add_ranking_screen
      # @survey wd have been set by params_check
      success = true
    end

    if success
      redirect_to survey_url(@survey)
    else
      flash[:alert] = t(:resource_creation_failure, resource_name: 'Survey')
      if params[:step_command] == 'init'
        render 'new'
      else
        render 'edit'
      end
    end
  end
  
  private
  def admin_signed_in?
    !current_admin.nil?
  end

  def params_check
    status = true
    case params[:action].to_sym
    when :show
      status &= params[:id].present? && (@survey = Survey.find_by_id params[:id])
    when :edit, :update
      # Need a valid command
      status &= params[:step_command]
      status &= valid_step?(params[:step_command])
      
      # Unless the command is to init, need a survey to edit
      unless params[:step_command].to_sym == :init
        valid_id = params[:with_survey].present? && (@survey = Survey.find_by_id params[:with_survey])
        status &= valid_id
      end
    end
    
    if !status
      redirect_to page_404
      false
    else
      true
    end
  end

  def total_steps
    2
  end

  def valid_step?(req)
    [:init, :add_ranking_screen].include? req.to_sym
  end 
end
