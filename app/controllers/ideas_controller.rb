class IdeasController < ApplicationController
  before_action :admin_signed_in?
  before_action :params_check, only: [:index, :show]

  def index
    @selected_section = 'ideas'

    if params[:for_survey]
      @ideas = [@survey.survey_questions.first.ideas.first]
    else
      @ideas = Idea.all
    end
    
    if params[:for_survey_question]
      @question = SurveyQuestion.find_by_id params[:for_survey_question].to_i
    end

    render (request.xhr? ? ({json: @ideas}) : ('index'))
  end

  def new
    @idea = Idea.new
  end

  def show
    @idea = Idea.find_by_id params[:id]
    @idea ? (request.xhr? ? render(json: @idea) : (render 'show')) : (redirect_to :root)
  end
  
  def create
    attrs = params[:idea].permit :title, :description
    i = Idea.new attrs
    if i.valid?
      i.save
      redirect_to idea_path i
    else
      flash[:alert] = t(:resource_creation_failure, resource_name: 'Idea')
      @idea = i and render 'new'
    end
  end
  
  private
  def admin_signed_in?
    !current_admin.nil?
  end

  def params_check
    status = true
    case params[:action].to_sym
    when :show
      status &= params[:id].present?
    when :index
      status &= (params[:for_survey].nil? || (@survey = Survey.find_by_id(params[:for_survey])))
    end

    if !status
      redirect_to page_404
    end

    return status
  end
end
