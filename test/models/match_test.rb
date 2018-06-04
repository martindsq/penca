require 'test_helper'

class MatchTest < ActiveSupport::TestCase

  test 'shoud be able to place a bet on a match that will start in more than 5 minutes' do
    unstarted_match = matches(:unstarted_match)
    upcoming_match = matches(:upcoming_match)
    started_match = matches(:started_match)
    endend_match = matches(:ended_match_with_home_victory)
    assert unstarted_match.is_bettable?
    assert_not upcoming_match.is_bettable?
    assert_not started_match.is_bettable?
    assert_not endend_match.is_bettable?
  end
  
  test 'unstarted match should not have a winning team' do
    unstarted_match = matches(:unstarted_match)
    assert_not unstarted_match.started?
    assert_not unstarted_match.ended?
    assert_nil unstarted_match.match_winning_team
  end

  test 'started match should not have a winning team' do
    started_match = matches(:started_match)
    assert started_match.started?
    assert_not started_match.ended?
    assert_nil started_match.match_winning_team
  end

  test 'ended match with victory should have a winning team' do
    ended_match_with_home_victory = matches(:ended_match_with_home_victory)
    assert ended_match_with_home_victory.started?
    assert ended_match_with_home_victory.ended?
    assert_not_nil ended_match_with_home_victory.match_winning_team
    assert_equal ended_match_with_home_victory.match_winning_team, ended_match_with_home_victory.home_team
    
    ended_match_with_away_victory = matches(:ended_match_with_away_victory)
    assert ended_match_with_away_victory.started?
    assert ended_match_with_away_victory.ended?
    assert_not_nil ended_match_with_away_victory.match_winning_team
    assert_equal ended_match_with_away_victory.match_winning_team, ended_match_with_away_victory.away_team
  end

  test 'ended match with tie should not have a winning team' do
    ended_match_with_tie = matches(:ended_match_with_tie)
    assert ended_match_with_tie.started?
    assert ended_match_with_tie.ended?
    assert_nil ended_match_with_tie.match_winning_team
  end

end
