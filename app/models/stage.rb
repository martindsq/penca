class Stage < ApplicationRecord
  validates :name, presence: true
  validates :stage_type, presence: true
  has_many :matches
  enum stage_type: [:group_stage, :knockout_stage]
  def to_s
    name
  end
end
