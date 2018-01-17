class Game < ApplicationRecord
    extend FriendlyId
    friendly_id :param, use: [:finders, :slugged]

    has_many :users, through: :speedruns
    has_many :runcats

    validates_presence_of :name, :slug

    before_save :prepare_slug



    private

    # Converts slug to all lowercase and swaps out spaces for underscores.
    def prepare_slug
        self.slug = slug.parameterize.underscore
    end

end
