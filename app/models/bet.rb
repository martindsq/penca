class Bet < ApplicationRecord
  validate :cannot_bet_on_a_started_match
  validates :match, uniqueness: { scope: :user }
  validates :home_score, numericality: { only_integer: true, less_than: 10 }
  validates :away_score, numericality: { only_integer: true, less_than: 10 }
  validates :winning_team, presence: true, if: :must_set_winning_team?

  before_validation :remove_winning_team

  belongs_to :user
  belongs_to :match
  belongs_to :winning_team, class_name: 'Team', optional: true

  def must_set_winning_team?
    match.stage.stage_type == "knockout_stage" && home_score == away_score
  end

  def self.bet(user, match)
    Bet.find_by(user: user, match: match)
  end

  def bet_winning_team
    if match.stage.stage_type == "group_stage"
      return if home_score == away_score
      return match.home_team if home_score > away_score
      match.away_team
    else
      return match.home_team if home_score > away_score
      return match.away_team if away_score > home_score
      winning_team
    end
  end

  def cannot_bet_on_a_started_match
    if !match.is_bettable?
      errors.add(:match, "already started")
    end
  end
  
  def points
    return if !match.ended?
    points = 0
    if home_score == match.home_score && away_score == match.away_score
      points += 10 
    end
    if bet_winning_team == match.match_winning_team
      points += 5 
    end
    points
  end

  private
  def remove_winning_team
    if !must_set_winning_team?
      self.winning_team = nil
    end
  end

end
