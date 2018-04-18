class Stadium < ApplicationRecord
  validates :name, presence: true
  validates :city, presence: true
  has_many :matches
  def to_s
    "#{name}, #{city}"
  end
end
