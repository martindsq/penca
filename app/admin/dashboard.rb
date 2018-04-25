ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel I18n.t("active_admin.ranking") do
          table_for User.invitation_accepted.sort{|a,b| a.points <=> b.points}.first(20) do
            column :alias
            column :email
            column t('active_admin.points'), :points
          end
        end
      end
      column do
        panel I18n.t("active_admin.pending_users").first(20) do
          table_for User.invitation_not_accepted do
            column :email
            column :invitation_sent_at
            column :invited_by
          end
        end
      end

    end 
  end
end
