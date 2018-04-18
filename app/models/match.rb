class Match < ApplicationRecord
  validates :time, presence: true
  validates :stadium, presence: true
  validates :home_team, presence: true
  validates :away_team, presence: true
  validates :home_score, presence: true, if: Proc.new { |b| b.away_score.present? }
  validates :away_score, presence: true, if: Proc.new { |b| b.home_score.present? }
  belongs_to :home_team, :class_name => 'Team'
  belongs_to :away_team, :class_name => 'Team'
  belongs_to :stadium
  belongs_to :stage
  has_many :bets

  def to_s
    "#{self.home_team.name} vs #{self.away_team.name}"
  end

  def started?
    Time.now >= time
  end

  def ended?
    home_score.present?
  end

  def winning_team
    return if !ended? || home_score == away_score
    return home_team if home_score > away_score
    away_team
  end

end
