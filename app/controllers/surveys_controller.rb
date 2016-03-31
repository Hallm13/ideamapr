class SurveysController < ApplicationController
  before_action :admin_signed_in?, except: :show 
  before_action :params_check, only: :show
  
  def show
    # Admins don't need to show token

    permitted = false
    @survey = Survey.find_by_id params[:id]
    if current_admin

      permitted = true
    else
      # Not admin - require token
      if params[:token] and @survey&.token == params[:token]
        permitted = true
      end
    end

    permitted ? (render 'show') : (raise ActionController::RoutingError.new(''))
  end

  def new
    current_step = params[:step].to_i
    @payload = {}
    @payload[:total_steps] = total_steps
    
    if params[:with_survey]
      if (@survey = Survey.find_by_id params[:with_survey]).nil?
        redirect_to page_404
        return
      end
    end
    
    case current_step
    when 1

    when 2
    else
      redirect_to page_404
      return
    end

    @payload[:current_step] = current_step
    @payload[:next_step] = current_step + 1 > total_steps ? -1 : current_step + 1
    
    render 'new'
  end

  def update
    if !(1..total_steps).include? params[:save_step].to_i
      redirect_to page_404
      return
    end

    success = false
    current_step = params[:save_step].to_i

    case current_step
    when 1
      s = Survey.new(title: params[:title], status: Survey::SurveyStatus::DRAFT)
      if s.valid?
        s.save
        success = true
      end
    when 2
    end

    next_step = current_step + (success ? 1 : 0)
    flash[:alert] = t(:resource_creation_failure, resource_name: 'Survey') unless status
    redirect_to surveys_url(step: next_step), alert: flash[:alert]    
  end
  
  private
  def admin_signed_in?
    !current_admin.nil?
  end

  def params_check
    params[:id].present?
  end

  def total_steps
    2
  end
end
