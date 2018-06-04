class Match < ApplicationRecord
  
  validates :time, presence: true
  validates :stadium, presence: true
  validates :home_team, presence: true
  validates :away_team, presence: true
  validates :home_score, presence: true, if: Proc.new { |b| b.away_score.present? }
  validates :away_score, presence: true, if: Proc.new { |b| b.home_score.present? }
  validates :winning_team, presence: true, if: :must_set_winning_team?
  
  before_validation :remove_winning_team
  
  belongs_to :home_team, :class_name => 'Team'
  belongs_to :away_team, :class_name => 'Team'
  belongs_to :stadium
  belongs_to :stage
  belongs_to :winning_team, class_name: 'Team', optional: true

  has_many :bets
  
  def must_set_winning_team?
    stage.stage_type == "knockout_stage" && home_score == away_score && (home_score.present? || away_score.present?)
  end

  def to_s
    "#{self.home_team.name} vs #{self.away_team.name}"
  end

  def started?
    Time.now > time
  end

  def ended?
    return false if !started?
    home_score.present?
  end

  def is_bettable?
    Time.now <= time - 5.minutes
  end

  def match_winning_team
    if stage.stage_type == "group_stage"
      return if home_score == away_score || !ended?
      return home_team if home_score > away_score
      away_team
    else
      return home_team if home_score > away_score
      return away_team if away_score > home_score
      winning_team
    end
  end

  private
  def remove_winning_team
    if !must_set_winning_team?
      self.winning_team = nil
    end
  end

end
