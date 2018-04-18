class RegistrationsController < Devise::RegistrationsController
  private
  def account_update_params
    puts "Hola"
    params.require(:user).permit(:alias, :email, :password, :password_confirmation, :current_password)
  end
end
