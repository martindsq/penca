ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel I18n.t("active_admin.ranking") do
          table_for User.invitation_accepted.sort{|a,b| a.points <=> b.points} do
            column :alias
            column :email
            column :points
          end
        end
      end
    end 
  end
end
