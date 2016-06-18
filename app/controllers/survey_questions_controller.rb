class SurveyQuestionsController < ApplicationController
  include RelationalLogic
  before_action :set_menubar_variables
  before_action :set_public_survey_or_admin!
  before_action :params_check

  def show
  end
  
  def index
    rendered = false

    if @survey&.published? && !current_admin
      @questions = @survey.survey_questions
    else
      @questions = SurveyQuestion.all
    end

    if @survey
      @excluded_qn_list = @survey.question_assignments.pluck(:survey_question_id, :ordering)
    end
    
    render (request.xhr? ? ({json: json_payload}) : 'index')
  end

  def new
    set_dropdown_options
    @level2_menu = :create_survey_question
  end
  
  def edit
    set_dropdown_options
    @level2_menu = :edit_survey_question
    
    @qn_idea_assignments = @question.idea_assignments
  end

  def update
    if save_question
        redirect_to survey_question_url(@question)
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
      component_array = (JSON.parse(params[:question_details]))['details'].sort_by { |i| i['idea_rank']}
      
      if @question.question_type == SurveyQuestion::QuestionType::RADIO_CHOICES ||
         @question.question_type == SurveyQuestion::QuestionType::TEXT_FIELDS

        # the array of fields should be annotated with ids, so they can be consumed correctly
        # later when loaded in Backbone as a collection
        question_details = component_array.each_with_index.map do |item, idx|
          item['id'] = idx
          item
        end
      else 
        idea_ids = component_array&.map { |i|  i['id'] } || []
      end
    end    
    
    if (saved = @question.valid?)
      ActiveRecord::Base.transaction do      
        saved &= @question.save

        if idea_ids.present?
          update_has_many!(@question, 'Idea', 'IdeaAssignment', idea_ids, polymorphic: true, foreign_key: 'groupable_id',
                           should_delete: true)
          
          # For idea questions, that have budgets assigned...
          if @question.question_type == SurveyQuestion::QuestionType::BUDGETING
            new_assignments = @question.idea_assignments.all.to_a.map do |ia|
              idea_rev_index = component_array.inject({}) do |memo, hash|
                memo[hash['id']] = hash
                memo
              end

              if idea_rev_index.keys.include? ia.idea_id.to_s
                ia.budget = idea_rev_index[ia.idea_id.to_s]['cart_amount'].to_f
              end

              ia
            end
            
            IdeaAssignment.import new_assignments,
                                  on_duplicate_key_update: { conflict_target: :id, columns: [:budget] }
          end
        elsif question_details.present?
          # There might be a record of Question Details already - delete it and refresh.
          if @question.question_detail.present?
            saved &= @question.question_detail.delete
          end

          # Backbone app will send the example fields as well that need to be filtered away here.
          clean_qd = question_details.sort_by {|i| i['idea_rank']}.reject {|i| /click to add/i.match(i['text'])}
          saved &= QuestionDetail.create survey_question: @question,
                                         details_list: clean_qd
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
      # We have already passed the public survey test which would have assigned @survey
      status &= @survey.present? || (params[:for_survey].blank? || (@survey = Survey.find_by_id(params[:for_survey])))
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

  def json_payload
    # Create a payload, mainly for Backbone app consumption, that allows display in multiple sections

    rev_index = @excluded_qn_list&.inject({}) do |memo, pair|
      memo[pair[0]] = pair[1] # key = qn id; val = ordering
      memo
    end

    jp = @questions.map do |qn|
      {id: qn.id, title: qn.title, question_prompt: qn.question_prompt, question_type: qn.question_type}.
        merge(rev_index.nil? ? {} : {question_rank: rev_index[qn.id],
                                     is_assigned: rev_index.keys.include?(qn.id)})
    end
    jp
  end
  
  def set_public_survey_or_admin!
    # Published surveys can have their questions revealed
    # if the survey's token is presented (via JSON)

    if params[:for_survey].nil?
      return authenticate_admin!
    end
    
    if request.xhr?
      s = Survey.find_by_public_link(params[:for_survey])
      if s && s.status == Survey::SurveyStatus::PUBLISHED
        @survey = s
        Rails.logger.debug 'Found public survey for sq index'
        return true
      end

      if s.nil?
        s = Survey.find_by_id params[:for_survey]
      end
      if s.nil?
        # if the survey can't be found, it doesn't matter who's logged in
        return false
      end
    else
      s = Survey.find_by_id(params[:for_survey]) || Survey.find_by_public_link(params[:for_survey])
    end
    
    @survey = s
    authenticate_admin!
  end  
end
