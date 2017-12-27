class Game < ApplicationRecord
    extend FriendlyId
    friendly_id :param, use: [:finders, :slugged]

    validates_presence_of :slug

end
