class SurveyQuestionsController < ApplicationController
  include RelationalLogic
  include PublishedDataChecks
  
  before_action :set_public_survey_or_admin!
  before_action :params_check, except: :new

  def show
  end
  
  def index
    rendered = false
    
    if request.xhr?
      # For non JSON requests, we need the @survey object for rendering purposes which is set
      # in the before filter for JSON requests, for Backbone processing.
      set = @survey&.survey_questions
      set ||= {}

      render json: set, include: [:ideas]
    else
      if @survey
        excluded_ids = @survey.survey_questions.pluck(:id)
        @questions = SurveyQuestion.where('id not in (?)', excluded_ids)
      else
        @questions = SurveyQuestion.all
      end
      render 'index'
    end
  end
  
  def edit
    set_dropdown_options
    
    if params[:id] != '0'
      @qn_idea_assignments = @question.idea_assignments
    end
    
    if params[:survey_question]&.send(:[], :components)
      @qn_ideas ||= []
      @qn_ideas += Idea.where('id in (?)', params[:survey_question][:components]).to_a
    end
  end

  def update
    set_dropdown_options

    attrs = params[:survey_question].permit(:title, :question_type, :question_prompt, :budget)
    @question.attributes= attrs

    idea_ids = params[:survey_question][:components]&.map { |i| i.to_i} || []
    if (saved = @question.valid?)
      ActiveRecord::Base.transaction do      
        saved &= @question.save
        update_has_many! @question, 'Idea', 'IdeaAssignment', idea_ids, polymorphic: true, foreign_key: 'groupable_id'

        # For ideas that have budgets assigned...
        if @question.question_type == SurveyQuestion::QuestionType::BUDGETING &&
           !(params[:survey_question][:budgets]&.keys.blank?)
          new_assignments = @question.idea_assignments.all.map do |ia|
            if params[:survey_question][:budgets].keys.include?(ia.idea_id.to_s)
              ia.budget = params[:survey_question][:budgets][ia.idea_id.to_s].to_f
            end

            ia
          end
          
          IdeaAssignment.import new_assignments,
                                on_duplicate_key_update: { conflict_target: :id, columns: [:budget] }
        end
      end
    end
    
    if saved
      case params[:redirect]
      when 'goto-contained'
        redirect_to ideas_url(add_to_survey_question: @question.id)
      when 'edit'
        redirect_to edit_survey_question_url(@question)
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
    case params[:action]
    when 'edit'
      status &= (params[:id] and (params[:id]=='0' || (@question = SurveyQuestion.find_by_id(params[:id]))))
    when 'update'
      status &= (params[:id] and (params[:id]=='0' || (@question = SurveyQuestion.find_by_id(params[:id]))))
      status &= !params[:survey_question].nil?
    when 'show'
      status &= params[:id] and (@question = SurveyQuestion.find_by_id params[:id])
    when 'index'
      unless request.xhr?
        status &= (params[:for_survey].nil? || (@survey = Survey.find_by_id(params[:for_survey])))
        if params[:add_to_survey]
          status &= (@survey = Survey.find_by_id params[:add_to_survey])
        end
      end
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
    @select_default = @question.question_type
  end
end
