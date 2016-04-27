class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action do
    # Quite a few things to do before the app starts...
    I18n.locale = set_locale
  end

  rescue_from ActionController::RoutingError do |exception|
    error_message = I18n.t(:message_404)
    redirect_to page_404
  end

  protected
  def admin_for_drafts!
    # specific requests for published data is allowed
    if request.xhr? &&
       !params[:for_survey].nil? && (@survey=Survey.find_by_id(params[:for_survey])) != nil &&
        @survey.status == Survey::SurveyStatus::PUBLISHED
      true
    else
      authenticate_admin!
    end
  end
  
  private
  def set_locale
    # 1. Let's make our app use the locale
    
    params[:locale] || I18n.default_locale
  end

  def go_to_root(message)
    redirect_to root_path, :alert => message
  end 

  def self.default_url_options(options={})
    { locale: I18n.locale }
  end

  def page_404
    '/404.html'
  end
end
