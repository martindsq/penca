class AddAdvancesToBet < ActiveRecord::Migration[5.1]
  def change
    add_reference :bets, :winning_team, index: true
    add_foreign_key :bets, :teams, column: :winning_team_id
  end
end
