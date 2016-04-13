class SurveysController < ApplicationController
  include SqlOptimizers
  include RelationalLogic
  
  before_action :authenticate_admin!, except: :public_show 
  before_action :params_check, except: [:new, :index]

  def index
    @selected_section = 'surveys'
    @surveys = Survey.all
  end

  def public_show
    # Not admin - require token
    if @survey.token == params[:token]
       render 'public_show'
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
      @survey_qns = @survey.survey_questions.to_a
    end
    
    if params[:survey]&.send(:[], :qns)
      @survey_qns ||= []
      @survey_qns += SurveyQuestion.where('id in (?)', params[:survey][:qns]).to_a
    end
  end
  
  def update
    success = false
    set_dropdown
    
    attrs = params[:survey].permit(:title, :introduction, :status)
    @survey.attributes= attrs
    @survey.owner_id = current_admin.id
    @survey.owner_type = 'Admin'      

    if (saved = @survey.valid?)
      sqn_ids = params[:survey][:qns]&.map { |i| i.to_i} || []
      ActiveRecord::Base.transaction do      
        saved &= @survey.save
        saved &= update_has_many!(@survey, 'SurveyQuestion', 'QuestionAssignment', sqn_ids)
      end
    end
  
    if saved
      # We saved so we can add questions
      if params[:redirect] == 'goto-contained'
        redirect_to survey_questions_url(for_survey: @survey.id)
      else
        redirect_to survey_url(@survey)
      end
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
      when :show, :public_show
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
