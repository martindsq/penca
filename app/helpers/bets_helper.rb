module BetsHelper

  def user_points(user)
    Match.all.inject(0) { |sum, match| 
      bet = Bet.find_by(match: match, user: user)
      sum + (bet_points(bet, match) || 0)
    }
  end

  def bet_points(bet, match)
    home_score = bet&.home_score || 0
    away_score = bet&.away_score || 0
    winning_team = bet&.winning_team || nil
    if match.ended?
      points = 0
      if home_score == match.home_score
        points += 5
      end
      if away_score == match.away_score
        points += 5
      end
      if winning_team == match.winning_team
        points += 5
      end
      return points
    else
      nil
    end
  end

end
