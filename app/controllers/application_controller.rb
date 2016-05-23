class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery  with: :exception

  before_action         :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u|
      u.permit(:password, :password_confirmation, :current_password)
    }
  end

  rescue_from CanCan::AccessDenied do |exception|
    render json: { 'message': exception.message }
  end

  def after_sign_in_path_for(resource)
    unless current_user.nil?
      Log.create!(activity: 'Sisteme giriş yapıldı', user_id: current_user.id,
                  user_agent: request.user_agent, ip: request.remote_ip)
    end

    stored_location_for(resource) || root_path
  end

  def access_denied(exception)
    redirect_to admin_dashboard_path, :alert => exception.message
  end
end