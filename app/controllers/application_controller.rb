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
    go_to_root(error_message)
  end

  private
  def set_locale
    # 1. Let's make our app use the locale
    
    params[:locale] || I18n.default_locale
  end

  def go_to_root(message)
    redirect_to root_path, :alert => message
  end 

  # Use URL options to set locale. I prefer it that way. Making this a class method because
  # Devise-based tests will fail otherwise (See https://github.com/plataformatec/devise/issues/1408)
  def self.default_url_options(options={})
    { locale: I18n.locale }
  end
end
