class Runcat < ApplicationRecord
  belongs_to :game

  validates :category, :presence => true
  validates :rules, :presence => true
end
