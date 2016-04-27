class SurveyQuestionsController < ApplicationController
  before_action :admin_for_drafts!
  before_action :params_check, except: [:new, :index]
  include RelationalLogic
  
  def index
    @selected_section = 'questions'
    rendered = false
    
    if params[:for_survey]
      unless @survey
        @survey = Survey.find_by_id params[:for_survey]
      end
    end
    
    if request.xhr?
      # For non JSON requests, we need the @survey object for rendering purposes which is set
      # in the before filter for JSON requests, for Backbone processing.
      set = @survey&.survey_questions
      set ||= {}
      render json: set
    else
      @questions = SurveyQuestion.all
      render 'index'
    end
  end
  
  def edit
    set_dropdown_options
    
    if params[:id] != '0'
      @qn_ideas = @question.ideas.to_a
    end
    
    if params[:survey_question]&.send(:[], :components)
      @qn_ideas ||= []
      @qn_ideas += Idea.where('id in (?)', params[:survey_question][:components]).to_a
    end
  end

  def update
    set_dropdown_options

    attrs = params[:survey_question].permit(:title, :question_type, :question_prompt)
    @question.attributes= attrs

    if (saved = @question.valid?)
      idea_ids = params[:survey_question][:ideas] || []

      ActiveRecord::Base.transaction do      
        saved &= @question.save
        update_has_many! @question, 'Idea', 'IdeaAssignment', idea_ids, polymorphic: true, foreign_key: 'groupable_id'
      end
    end
    
    if saved      
      if params[:redirect] == 'goto-contained'
        redirect_to ideas_url(for_survey_question: @question.id)
      else
        redirect_to survey_question_url(@question)
      end
    else
      flash[:alert] = t(:resource_creation_failure, resource_name: 'Survey Question')
      render :edit
    end
  end

  private
  def params_check
    status = true
    if params[:action] == 'update' or params[:action] == 'edit'
      status &= (params[:id] and (params[:id]=='0' || (@question = SurveyQuestion.find_by_id(params[:id]))))
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
  
  def set_dropdown_options
    @question_type_select = SurveyQuestion::QuestionType.option_array
    @select_default = SurveyQuestion::QuestionType.name(@question.question_type)
  end
end
