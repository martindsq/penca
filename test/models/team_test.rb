require 'test_helper'

class TeamTest < ActiveSupport::TestCase

  test "should not save team without name" do
    team = Team.new
    assert_not team.save, "Saved the team without a name"
  end

  test "should save team with name" do
    team = Team.new
    team.name = "Uruguay"
    assert team.save, "Didn't save the team with a name"
  end

  test "team should know a home match it participates" do
    team = Team.new
    team.name = "Uruguay"
    team.save()
    away_team = Team.new
    away_team.name = "Rusia"
    away_team.save()
    match = Match.new
    match.time = DateTime.current()
    match.home_team = team
    match.away_team = away_team
    match.save()
    assert_equal team.home_matches.count, 1, "Didn't have one home match"
    assert_equal team.away_matches.count, 0, "Didn't have zero away matches" 
  end

end

