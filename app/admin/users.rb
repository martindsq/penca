ActiveAdmin.register User do
  
  permit_params :email, :alias, :password, :password_confirmation
  
  filter :alias
  filter :email
  filter :invitation_sent_at
  filter :invitation_accepted_at

  actions :all, except: [:new, :edit]

  index do 
    id_column
    column :alias
    column :email
    column :invitation_sent_at
    column :invitation_accepted_at
    column :invited_by
    actions
  end

  collection_action :new_invitation do
	@user = User.new
  end 

  collection_action :new_user do
    @user = User.new
  end

  collection_action :send_invitation, :method => :post do
	@user = User.invite!(permitted_params[:user], current_admin)
	if @user.errors.empty?
      flash[:notice] = "User has been successfully invited. " + accept_user_invitation_url({invitation_token: @user.raw_invitation_token})
		redirect_to admin_users_path
	else
		messages = @user.errors.full_messages.map { |msg| msg }.join
		flash[:error] = "Error: " + messages
		redirect_to new_invitation_admin_users_path
	end
  end

  collection_action :create_user, :method => :post do
    now = Time.now
    devise_invitable_params = {:invitation_created_at => now,
                               :invitation_sent_at => now,
                               :invitation_accepted_at => now,
                               :invited_by => current_admin}
    @user = User.create(permitted_params[:user].merge(devise_invitable_params))
    if @user.errors.empty?
      flash[:notice] = "User has been successfully created."
      redirect_to admin_users_path
    else
      messages = @user.errors.full_messages.map { |msg| msg }.join
      flash[:error] = "Error: " + messages
      redirect_to new_user_admin_users_path
    end
  end

  action_item do
    link_to t('invite_new_user'), new_invitation_admin_users_path
  end

  action_item do
    link_to t('create_new_user'), new_user_admin_users_path
  end

  
end
