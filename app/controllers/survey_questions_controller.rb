class SurveyQuestionsController < ApplicationController
  include RelationalLogic
  include PublishedDataChecks

  before_action :set_menubar_variables
  before_action :set_public_survey_or_admin!
  before_action :params_check

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

  def new
    set_dropdown_options
    @level2_menu = :create_survey_question
  end
  
  def edit
    set_dropdown_options
    set_existing_counts
    @level2_menu = :edit_survey_question
    
    if params[:id] != '0'
      @qn_idea_assignments = @question.idea_assignments
    end
    
    if params[:survey_question]&.send(:[], :components)
      @qn_ideas ||= []
      @qn_ideas += Idea.where('id in (?)', params[:survey_question][:components]).to_a
    end
  end

  def update
    if save_question
      if /and add/i.match(params[:commit])
        redirect_to edit_survey_question_url(@question)
      else
        redirect_to survey_question_url(@question)
      end
    else
      set_dropdown_options
      flash.now[:alert] = t(:resource_creation_failure, resource_name: 'Survey Question')
      if params[:action] == 'update'
        render :edit
      else
        render :new
      end
    end
  end
  alias :create :update
  
  def save_question
    set_dropdown_options

    attrs = params[:survey_question].permit(:title, :question_type, :question_prompt, :budget)
    @question.attributes= attrs

    if !@question.question_prompt.present? or @question.question_prompt.strip.blank?
      # No blank prompts allowed
      @question.set_default_prompt
    end

    idea_ids = question_details = nil
    # We either got ideas or fields for a survey question
    if params[:question_details]
      component_array = (JSON.parse(params[:question_details]))['details']
      if @question.question_type == SurveyQuestion::QuestionType::RADIO_CHOICES ||
         @question.question_type == SurveyQuestion::QuestionType::TEXT_FIELDS
        question_details = component_array
      else 
        idea_ids = component_array&.map { |i| i['id']} || []
      end
    end    
    
    if (saved = @question.valid?)
      ActiveRecord::Base.transaction do      
        saved &= @question.save

        if !idea_ids.nil?
          update_has_many!(@question, 'Idea', 'IdeaAssignment', idea_ids, polymorphic: true, foreign_key: 'groupable_id',
                           should_delete: true)
          
          # For idea questions, that have budgets assigned...
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
        elsif !question_details.nil?
          # There might be a record of Question Details already - delete it and refresh.
          if @question.question_detail.present?
            saved &= @question.question_detail.delete
          end

          saved &= QuestionDetail.create survey_question: @question, details_list: (question_details.reject {|i| /click to add/i.match(i['text'])})
        end
      end
    end

    # If the transaction didn't succeed, this will cause the caller function to appropriately bail to the browser.
    saved
  end

  private
  def set_menubar_variables
    @navbar_active_section = :survey_questions
  end
  
  def params_check
    status = true
    case params[:action]
    when 'new'
      @question = SurveyQuestion.new

      # For use in view helpers
      @form_object = @question
    when 'edit'
      status &= (params[:id] and (@question = SurveyQuestion.find_by_id(params[:id])))
      # For use in view helpers
      @form_object = @question
    when 'update', 'create'
      status &= (params[:action] == 'create' && params[:id].nil?) || (@question = SurveyQuestion.find_by_id(params[:id]))
      status &= !params[:survey_question].nil?
      if @question.nil?
        @question = SurveyQuestion.new
      end
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

    status
  end
  
  def set_dropdown_options
    @question_type_select = SurveyQuestion::QuestionType.option_array
    @select_default = @question.question_type || 1 # default for new = Ranking... TODO change it maybe?
  end

  def set_existing_counts
    @existing_ideas_count =
      if params[:id] == 0
        0
      else
        @question.idea_assignments.count
      end
  end
end
