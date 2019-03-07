Rails.application.routes.draw do

  root                                'static_pages#home'
  get     '/about',               to: 'static_pages#about'
  get     '/admin',               to: 'static_pages#adminland', as: :adminland
  get     '/signup',              to: 'users#new'
  get     '/login',               to: 'sessions#new'
  get     '/games',               to: 'games#index',            as: :games_index
  get     '/games/:slug',         to: 'games#show',             as: :game
  get     '/admin/newgame',       to: 'games#new',              as: :new_game
  get     '/games/:slug/edit',    to: 'games#edit',             as: :edit_game
  get     '/run/:id',             to: 'speedruns#show',         as: :speedrun
  get     '/run/:id/edit',        to: 'speedruns#edit',         as: :edit_speedrun
  get     '/category/:id',        to: 'runcats#show',           as: :runcat
  get     '/category/:id/edit',   to: 'runcats#edit',           as: :edit_runcat

  post    '/login',               to: 'sessions#create'
  post    '/games',               to: 'games#create'

  patch   '/games/:slug',         to: 'games#update'
  patch   '/run/:id',             to: 'speedruns#update'
  patch   '/category/:id',        to: 'runcats#update'

  delete  '/logout',              to: 'sessions#destroy'
  delete  '/games/:slug',         to: 'games#destroy'
  # delete  '/run/:id',             to: 'speedruns#destroy'
  # delete  '/category/:id'         to: 'runcats#destroy'

  scope '/games' do
    # It would be too easy to let Rails route things for speedruns.
    # Speedruns/Runcats Controller routing is mapped manually here.
    get     '/:slug/runs',            to: 'speedruns#index',  as: :speedruns
    get     '/:slug/runs/new',        to: 'speedruns#new',    as: :new_game_speedrun
    # get     '/:slug/runs/:id/edit',   to: 'speedruns#edit',   as: :edit_game_speedrun
    post    '/:slug/runs',            to: 'speedruns#create'
    # patch   '/:slug/runs/:id',        to: 'speedruns#edit'
    delete  '/:slug/runs.:id',        to: 'speedruns#destroy'

     # Runcats Routing. See above.
    get     '/:slug/categories',            to: 'runcats#index',    as: :runcats
    get     '/:slug/categories/new',        to: 'runcats#new',      as: :new_game_runcat
    # get     '/:slug/categories/:id/edit',   to: 'runcats#edit',     as: :edit_game_runcat
    post    '/:slug/categories',            to: 'runcats#create'
    # patch   '/:slug/categories/:id',        to: 'runcats#edit'
    delete  '/:slug/categories.:id',        to: 'runcats#destroy'
  end

  # Games is routed manually due to the slugs interfering with standard resource urls
  # For compliance, some routes are named namually via the 'as' parameter.

  resources :users
  # This is broken, but is left as an example of subordinate routing.
  # resources :games do
  #   resources :speedruns
  # end
  
end
