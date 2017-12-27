class Game < ApplicationRecord
    attr_accessor :name, :slug

    validates_presence_of :slug
    
    # This allows 'slug' to be used to create friendly urls such as ~/games/metroid instead of ~/games/1
    def to_param
        slug
    end

end
