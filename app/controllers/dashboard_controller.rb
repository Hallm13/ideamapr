class DashboardController < ApplicationController
  before_action :admin_signed_in?

  def show
  end
  
  private
  def admin_signed_in?
    if current_admin.nil?
      redirect_to new_admin_session_path
      false
    end

    @selected_section = 'ideas'
    true
  end
end
