Rails.application.routes.draw do

  root                              'static_pages#home'
  get     '/about',             to: 'static_pages#about'
  get     '/admin',             to: 'static_pages#adminland', as: :adminland
  get     '/signup',            to: 'users#new'
  get     '/login',             to: 'sessions#new'
  get     '/games',             to: 'games#index',            as: :games_index
  get     '/games/:slug',       to: 'games#show',             as: :game
  get     '/admin/newgame',     to: 'games#new',              as: :new_game
  get     '/games/:slug/edit',  to: 'games#edit',             as: :edit_game

  post    '/login',             to: 'sessions#create'
  post    '/games',             to: 'games#create'

  patch   '/games/:slug/edit',  to: 'games#update'

  delete  '/logout',            to: 'sessions#destroy'
  delete  '/games/:slug',       to: 'games#destroy'

  resources :users
  # Games is routed manually due to the slugs interfering with standard resource urls
  # For compliance, some routes are named namually via the 'as' parameter.
  
end
