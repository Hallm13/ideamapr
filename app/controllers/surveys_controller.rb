class SurveysController < ApplicationController
  include SqlOptimizers
  include RelationalLogic
  
  before_action :authenticate_admin!, except: :show 
  before_action :params_check, except: [:new, :index]

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
    set_dropdown
    if params[:id] == '0'
      @survey = Survey.new
    end
  end
  
  def update
    success = false
    set_dropdown
    
    attrs = params[:survey].permit(:title, :status)
    @survey.attributes= attrs

    saved = false
    if @survey.valid?
      @survey.save
      saved = true
    end
  
    if saved
      redirect_to survey_url(@survey)
    else
      flash[:alert] = t(:resource_creation_failure, resource_name: 'Survey')
      render :edit
    end
  end
  
  private
  def params_check
    status = true
    status &= params[:id]

    if status
      case params[:action].to_sym
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
      false
    else
      true
    end
  end
  
  def set_dropdown
    @survey_status_select = Survey::SurveyStatus.option_array
    @select_default = Survey::SurveyStatus.name(@survey.status)
  end
end
