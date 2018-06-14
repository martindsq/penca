class User < ApplicationRecord
  validates_presence_of :alias, :on => :update
  validates_uniqueness_of :alias, :on => :update
  validates :alias, length: { in: 3..20 }, on: :update
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:alias]
  has_many :bets

  def self.sorted_by_points
    User.includes(bets: [:match]).invitation_accepted.sort_by(&:points)
  end

  def points
    bets.inject(0) { |sum, bet| sum + (bet&.points || 0)} 
  end

end
