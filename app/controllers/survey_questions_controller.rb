class SurveyQuestionsController < ApplicationController
  before_action :authenticate_admin!
  before_action :params_check, except: [:new, :index]

  def index
    @questions = SurveyQuestion.all
  end
  
  def new
    @question = SurveyQuestion.new
  end

  def edit
    @payload = {}
    @payload[:step_command] = params[:step_command]
    set_dropdown_options
  end

  def update
    set_dropdown_options
  end

  def create
    attrs = params[:survey_question].permit(:title)
    @question = SurveyQuestion.new attrs
    if @question.valid?
      @question.save
      redirect_to survey_questions_path
    else
      flash[:alert] = t(:resource_creation_failure, resource_name: 'Question')
      render :new
    end
  end

  private
  def params_check
    status = true
    if params[:action] == 'update' or params[:action] == 'edit'
      status &= (params[:id] and (@question = SurveyQuestion.find_by_id(params[:id])))
      if params[:action] == 'edit'
        status &= valid_command?(params[:step_command])
      end
    end

    if params[:action] == 'update' or params[:action] == 'create'
      status &= !params[:survey_question].nil?
    end

    if !status
      redirect_to page_404
    end
    status
  end

  def valid_command?(req)
    [:multi_idea_add, :single_idea_add].include?(req.to_sym)
  end

  def set_dropdown_options
    @question_type_select = SurveyQuestion::QuestionType.multi_idea_commands
    @select_default = SurveyQuestion::QuestionType.name(@question.question_type)
  end
end
