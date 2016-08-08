class IdeasController < ApplicationController
  before_action :set_menubar_variables
  before_action :authenticate_admin!
  before_action :params_check

  helper IdeasHelper
  
  def new
    @level2_menu = :create_idea
  end
    
  def index
    @all_ideas = Idea.order(created_at: :desc).map do |i|
      base_info = {id: i.id, title: i.title, description: i.description}
      if (img = i.card_image)
        base_info.merge!({image_url: img.downloadable.url})
      else
        base_info.merge!({image_url: ''})
      end

      base_info
    end
    
    if params[:for_survey_question]
      selected_idea_assignments =
        if params[:for_survey_question].to_i == 0
          # new survey questions have no ideas
          []
        else
          @question.idea_assignments.pluck(:idea_id, :ordering, :budget)
        end
      assignments_rev_index =
        selected_idea_assignments.inject({}) do |memo, rec_data|
        memo[rec_data[0]] = {ordering: rec_data[1], budget: rec_data[2]}
        memo
      end
      @all_ideas.each do |idea_rec|
        i = idea_rec[:id]
        if (already_assigned = assignments_rev_index.keys.include?(i))
          idea_rec.merge!({component_rank: assignments_rev_index[i][:ordering],
                           cart_amount: assignments_rev_index[i][:budget]})
        end
        idea_rec.merge!({is_assigned: already_assigned})
      end
    end

    render json_payload
  end

  def edit
    @level2_menu = :create_idea
    if @idea.download_files.count > 0
      @attachments_oldest_first = @idea.attachments_oldest_first
    end
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
      if params[:idea][:attachment]
        df = DownloadFile.new downloadable: params[:idea][:attachment]
        df.idea = @idea
        df.save
      end
      
      redirect_to ideas_path @idea
    else
      flash.now[:alert] = t(:resource_creation_failure, resource_name: 'Idea')
      render (params[:action] == 'create' ? :new : :edit)
    end
  end
  alias :create :update
  
  private
  def json_payload
    if request.xhr?
      {json: @all_ideas}
    else
      'index'
    end
  end
  
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
    when :index
      # XHR request for new SQ will send SQ id = 0
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
