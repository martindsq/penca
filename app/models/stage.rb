class Stage < ApplicationRecord
  
  validates :name, presence: true
  validates :stage_type, presence: true
  has_many :matches
  enum stage_type: [:group_stage, :knockout_stage]
  
  def self.group_stages
    where(stage_type: :group_stage)
  end

  def self.knockout_stages
    where(stage_type: :knockout_stage)
  end

  def to_s
    name
  end

end
