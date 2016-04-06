class SurveyQuestionsController < ApplicationController
  before_action :authenticate_admin!
  before_action :params_check, except: [:new, :index]
  include RelationalLogic
  
  def index
    @questions = SurveyQuestion.all
  end
  
  def edit
    @payload = {step_command: :idea_add}

    set_dropdown_options
  end

  def update
    attrs = params[:survey_question].permit(:title, :question_type, :question_prompt)
    @question.attributes= attrs

    saved = false
    if @question.valid?
      idea_ids = params[:survey_question][:ideas]

      ActiveRecord::Base.transaction do      
        @question.save
        update_has_many @question, 'Idea', idea_ids, polymorphic: true, foreign_key: 'groupable_id'
      end
      saved = true
    end
    if saved
      redirect_to survey_questions_path      
    else
      flash[:alert] = t(:resource_creation_failure, resource_name: 'Question')
      render :edit
    end
  end

  private
  def params_check
    status = true
    if params[:action] == 'update' or params[:action] == 'edit'
      status &= (params[:id] and (params[:id]=='0' || (@question = SurveyQuestion.find_by_id(params[:id]))))
      if params[:action] == 'edit'
        status &= valid_command?(params[:step_command])
      end
    end

    if params[:action] == 'update'
      status &= !params[:survey_question].nil?
    end

    if !status
      redirect_to page_404
    end

    if params[:id] == '0'
      @question = SurveyQuestion.new
    end
    
    status
  end

  def valid_command?(req)
    [:idea_add].include?(req.to_sym)
  end

  def set_dropdown_options
    @question_type_select = SurveyQuestion::QuestionType.option_array
    @select_default = SurveyQuestion::QuestionType.name(@question.question_type)
  end
end
