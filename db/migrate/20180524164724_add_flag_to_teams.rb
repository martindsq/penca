class AddFlagToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :flag, :string
  end
end
