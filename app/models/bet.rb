class Bet < ApplicationRecord
  validate :cannot_bet_on_a_started_match
  validates :match, uniqueness: { scope: :user }
  validates :home_score, numericality: { only_integer: true, less_than: 10 }
  validates :away_score, numericality: { only_integer: true, less_than: 10 }

  belongs_to :user
  belongs_to :match

  def self.bet(user, match)
    Bet.find_by(user: user, match: match)
  end

  def winning_team
    return if home_score == away_score
    return match.home_team if home_score > away_score
    match.away_team
  end

  def cannot_bet_on_a_started_match
    if match.started?
      errors.add(:match, "already started")
    end
  end

  def points
    return if !match.ended?
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
    points
  end

end
