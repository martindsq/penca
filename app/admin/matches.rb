ActiveAdmin.register Match do
  permit_params :time, 
                :stadium_id,
                :stage_id,
                :home_team_id, 
                :away_team_id, 
                :home_score,
                :away_score,
                :winning_team_id

  filter :time
  filter :stage
  filter :home_team
  filter :away_team

  controller do
    def scoped_collection
      super.includes :stage, :home_team, :away_team
    end
  end

  index do
    id_column
    column :time
    column :stage
    column t('teams') do |m|
      "#{m.home_team.name} vs #{m.away_team.name}"
    end
    column t('active_admin.result') do |m|
      "#{m.home_score}-#{m.away_score}" if m.ended? 
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :home_team
      f.input :away_team
      f.input :stadium
      f.input :stage
      f.input :time
      if !f.object.new_record?
        f.input :home_score
        f.input :away_score
        if f.object.stage.stage_type == 'knockout_stage'
          f.input :winning_team, :collection => [
            [resource.home_team.name, resource.home_team.id],
            [resource.away_team.name, resource.away_team.id]
          ]
        end
      end
    end
    actions
  end

end
