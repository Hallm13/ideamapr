class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_strong_params"

    params[resource] &&= send(method, params[resource]) if respond_to?(method, true)
  end

  rescue_from CanCan::AccessDenied do |exception|
    if request.env.key? "HTTP_REFERER"
      redirect_to :back, :alert => exception.message
    else
      redirect_to root_url, :alert => exception.message
    end
  end 
  
end
