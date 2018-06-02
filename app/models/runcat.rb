class Runcat < ApplicationRecord
  belongs_to :game

  validates :category, :presence => true
  validates :rules, :presence => true

  def get_category
    self.category
  end
end
