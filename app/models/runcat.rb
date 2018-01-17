class Runcat < ApplicationRecord
  belongs_to :game

  validates_presence_of :category
end
