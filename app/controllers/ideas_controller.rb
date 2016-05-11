class IdeasController < ApplicationController
  include PublishedDataChecks
  
  before_action :set_public_survey_or_admin!
  before_action :params_check

  def index
    @selected_section = 'ideas'

    if params[:for_survey]
      @ideas = @survey.survey_questions.order(created_at: :desc).first.ideas.order(created_at: :desc)
    elsif params[:for_survey_question]
      @question = SurveyQuestion.find_by_id params[:for_survey_question].to_i

      # To index by a survey question, you need to have provided the survey also unless you are an admin
      if current_admin || @survey.questions.include?(@question)
        @ideas = @question.ideas
      else
        @ideas = []
      end
    else
      if @question
        excluded_ids = @question.ideas.pluck(:id)
        if excluded_ids.blank?
          @ideas = Idea.all
        else
          @ideas = Idea.where('id not in (?)', excluded_ids)
        end
      else
        @ideas = Idea.all
      end
    end

    render (request.xhr? ? ({json: @ideas.to_a}) : ('index'))
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
  
  private
  def params_check
    status = true
    case params[:action].to_sym
    when :show
      status &= params[:id].present?
    when :index
      status &= (params[:for_survey].nil? || (@survey = Survey.find_by_id(params[:for_survey])))
      if params[:add_to_survey_question]
        status &= (@question = SurveyQuestion.find_by_id params[:add_to_survey_question])
      end
    when :edit, :update
      unless params[:id] == '0'
        status &= (@idea = Idea.find_by_id params[:id])
      end
    end
    if params[:id] == '0'
      @idea = Idea.new
    end

    if !status
      redirect_to page_404
    end

    return status
  end
end
