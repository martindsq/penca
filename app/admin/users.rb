ActiveAdmin.register User do
  
  permit_params :email
  
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
    actions
  end

  collection_action :new_invitation do
	@user = User.new
  end 

  collection_action :send_invitation, :method => :post do
	@user = User.invite!(permitted_params[:user], current_user)
	if @user.errors.empty?
		flash[:notice] = "User has been successfully invited."
		redirect_to admin_users_path
	else
		messages = @user.errors.full_messages.map { |msg| msg }.join
		flash[:error] = "Error: " + messages
		redirect_to new_invitation_admin_users_path
	end
  end

  action_item do
    link_to 'Invite New User', new_invitation_admin_users_path
  end

  
end
