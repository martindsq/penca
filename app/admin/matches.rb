ActiveAdmin.register Match do
  permit_params :time, 
                :stadium_id,
                :stage_id,
                :home_team_id, 
                :away_team_id, 
                :home_score,
                :away_score

  filter :time
  filter :stadium
  filter :stage
  filter :home_team
  filter :away_team
  filter :home_score
  filter :away_score

  index do
    id_column
    column :time
    column :stadium
    column :stage
    column t('teams') do |m|
      "#{m.home_team.name} vs #{m.away_team.name}"
    end
    column t('active_admin.result') do |m|
      "#{m.home_score}-#{m.away_score}" if m.ended? 
    end
    actions
  end

end
