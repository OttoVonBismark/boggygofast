class StaticPagesController < ApplicationController
    
    before_action :admin_user, only: :adminland

    def home
    end

    def about
    end

    def adminland
    end

end
