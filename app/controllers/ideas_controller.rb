class IdeasController < ApplicationController
  before_action :set_menubar_variables
  before_action :params_check

  def new
    @level2_menu = :create_idea
  end
  
  def double_bundle
    if params[:for_survey]
      # This is going to be a list of lists ... for a survey ... so it has to be returned as if it's a
      # model. All ideas for a survey - would an admin ever ask for this? TODO
      list_of_lists = @survey.question_assignments.order(:ordering).map do |sq_assign|
        # TODO this is _so_ inefficient. N+1 queries, etc.
        sq = sq_assign.survey_question
        ideas = Idea.where('id in (?)', sq.idea_assignments.order(:ordering).pluck(:idea_id))
      end
      @all_ideas = {list_of_lists: list_of_lists}
    else
      @all_ideas = {list_of_lists: []}
    end
    render (request.xhr? ? ({json: @all_ideas}) : ('index'))    
  end
  
  def index
    if params[:for_survey_question]
      # To index by a survey question, you need to have provided the survey also unless you are an admin
      if current_admin || @survey.questions.include?(@question)
        @all_ideas = Idea.all
        selected_idea_assignments = if params[:for_survey_question].to_i == 0
                           # new survey questions have no ideas
                           []
                         else
                           @question.idea_assignments.pluck(:idea_id, :ordering)
                         end
        existing_ids = selected_idea_assignments.inject({}) { |memo, pair| memo[pair[0]] = pair[1]; memo; }
                             
        @all_ideas = @all_ideas.map do |i|
          {id: i.id, title: i.title, description: i.description}.merge({is_assigned: existing_ids.keys.include?(i.id),
                                                                        idea_rank: existing_ids[i.id]})
        end
      else
        @all_ideas = []
      end
    else
      # There is neither a survey or an SQ specified in the params, to key ideas against
      @all_ideas = Idea.all
    end

    render (request.xhr? ? ({json: @all_ideas}) : ('index'))
  end

  def edit
  end

  def show
    @idea = Idea.find_by_id params[:id]
    @idea ? (request.xhr? ? render(json: @idea) : (render 'show')) : (redirect_to page_404)
  end
  
  def update
    attrs = params[:idea].permit :title, :description
    @idea.attributes= attrs

    if @idea.valid?
      @idea.save
      redirect_to idea_path @idea
    else
      flash[:alert] = t(:resource_creation_failure, resource_name: 'Idea')
      render :edit
    end
  end
  alias :create :update
  
  private
  def set_menubar_variables
    @navbar_active_section = :ideas
  end

  def params_check
    status = true
    case params[:action].to_sym
    when :new
      @idea = Idea.new
      # For use in view helpers
      @form_object = @idea      
    when :show, :edit
      status &= (params[:id].present? and @idea=Idea.find_by_id(params[:id]))
      # For use in view helpers
      @form_object = @idea
    when :double_bundle
      status &= (params[:for_survey].present? &&
                 (@survey = Survey.find_by_public_link(params[:for_survey])) &&
                 (@survey.published? || current_admin))
    when :index
      status &= (params[:for_survey_question].nil? || params[:for_survey_question].to_i == 0 ||
                 (@question = SurveyQuestion.find_by_id(params[:for_survey_question])))
    when :create, :update
      status &= (params[:id].nil? || (@idea = Idea.find_by_id(params[:id])))
      status &= !params[:idea].nil?
      if @idea.nil?
        @idea = Idea.new
      end
    end

    if !status
      redirect_to page_404
    end

    return status
  end
end
