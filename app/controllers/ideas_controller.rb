class IdeasController < ApplicationController
  before_action :admin_signed_in?
  before_action :params_check, only: :show
  def new
    @idea = Idea.new
  end

  def show
    @idea = Idea.find_by_id params[:id]
    @idea ? (render 'show') : (redirect_to :root)
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
    params[:id].present?
  end
end
