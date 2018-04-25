class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
 
  def authenticate_inviter!
    authenticate_admin!(:force => true)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:alias])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:alias])
    devise_parameter_sanitizer.permit(:account_update, keys: [:alias, :email, :password, :current_password])
  end

  private

  def set_locale
    Time.zone = 'America/Montevideo'
    I18n.locale = :es
  end

  def set_admin_locale
    Time.zone = 'America/Montevideo'
    I18n.locale = :es
  end

end
