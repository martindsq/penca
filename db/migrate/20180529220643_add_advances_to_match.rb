class AddAdvancesToMatch < ActiveRecord::Migration[5.1]
  def change
    add_reference :matches, :winning_team, index: true
    add_foreign_key :matches, :teams, column: :winning_team_id
  end
end
