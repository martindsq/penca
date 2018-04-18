class User < ApplicationRecord
  validates_presence_of :alias, :on => :update
  validates_uniqueness_of :alias, :on => :update
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :bets
  
  def points
    bets.inject(0) { |sum, bet| sum + (bet&.points || 0)} 
  end

end
