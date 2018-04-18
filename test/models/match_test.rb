require 'test_helper'

class MatchTest < ActiveSupport::TestCase

  test "should not save match without time and teams" do
    match = Match.new
    assert_not match.save, "Saved the match without time nor teams"
  end

  test "should not save match without teams" do
    match = Match.new
    match.time = DateTime.current()
    assert_not match.save, "Saved the match without teams"
  end

  test "should not save match without time" do
    home_team = Team.new
    home_team.name = "Uruguay"
    away_team = Team.new
    away_team.name = "Rusia"
    match = Match.new
    match.home_team = home_team
    match.away_team = away_team
    assert_not match.save, "Saved the match without time"
  end

  test "should save match with time and teams" do
    home_team = Team.new
    home_team.name = "Uruguay"
    away_team = Team.new
    away_team.name = "Rusia"
    match = Match.new
    match.time = DateTime.current()
    match.home_team = home_team
    match.away_team = away_team
    assert match.save, "Didn't save the match with time and teams"

  end
end
