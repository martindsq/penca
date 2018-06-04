require 'test_helper'

class BetTest < ActiveSupport::TestCase

  

  test 'exact score must award 15 points' do
    john_bet_on_match_with_home_victory = bets(:john_predicted_home_victory_with_exact_score_on_match_with_home_victory)
    susan_bet_on_match_with_tie = bets(:susan_predicted_tie_with_exact_score_on_match_with_tie)
    assert_equal 15, john_bet_on_match_with_home_victory.points
    assert_equal 15, susan_bet_on_match_with_tie.points
  end

  test 'predicted winning team must award 5 points' do
    susan_bet_on_match_with_home_victory = bets(:susan_predicted_home_victory_on_match_with_home_victory)
    lily_bet_on_match_with_tie = bets(:lily_predicted_tie_on_match_with_tie)
    assert_equal 5, susan_bet_on_match_with_home_victory.points
    assert_equal 5, lily_bet_on_match_with_tie.points
  end

  test 'missed bets must award 0 points' do
    lily_bet_on_match_with_home_victory = bets(:lily_predicted_tie_on_match_with_home_victory)
    mark_bet_on_match_with_home_victory = bets(:mark_predicted_away_victory_on_match_with_home_victory)
    john_bet_on_match_with_tie = bets(:john_predicted_home_victory_on_match_with_tie)
    mark_bet_on_match_with_tie = bets(:mark_predicted_away_victory_on_match_with_tie)
    assert_equal 0, lily_bet_on_match_with_home_victory.points
    assert_equal 0, mark_bet_on_match_with_home_victory.points
    assert_equal 0, john_bet_on_match_with_tie.points
    assert_equal 0, mark_bet_on_match_with_tie.points
  end

  test 'bets on matches that did not end yet must not award points' do
    john_bet_on_started_match = bets(:john_predicted_home_victory_on_started_match)
    susan_bet_on_started_match = bets(:susan_predicted_tie_on_started_match)
    assert_nil john_bet_on_started_match.points
    assert_nil susan_bet_on_started_match.points
  end

  test 'bets on knockout matches that ended in tie must award points based on winning_team and exact score' do
    john_bet_on_knockout_match = bets(:john_predicted_home_victory_on_knockout_match)
    assert_equal 5, john_bet_on_knockout_match.points

    susan_bet_on_knockout_match = bets(:susan_predicted_tie_with_exact_score_and_winning_team_on_knockout_match)
    assert_equal 15, susan_bet_on_knockout_match.points

    lily_bet_on_knockout_match = bets(:lily_predicted_tie_with_exact_score_on_knockout_match)
    assert_equal 10, lily_bet_on_knockout_match.points

    mark_bet_on_knockout_match = bets(:mark_predicted_tie_and_winning_team_on_knockout_match)
    assert_equal 5, mark_bet_on_knockout_match.points

    carol_bet_on_knockout_match = bets(:carol_predicted_tie_on_knockout_match)
    assert_equal 0, carol_bet_on_knockout_match.points
  end

end
