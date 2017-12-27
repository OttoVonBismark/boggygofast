Rails.application.routes.draw do

  root                              'static_pages#home'
  get     '/about',             to: 'static_pages#about'
  get     '/signup',            to: 'users#new'
  get     '/login',             to: 'sessions#new'
  get     '/games',             to: 'games#index'
  get     '/games/:slug',       to: 'games#show'
  get     '/admin/newgame',     to: 'games#new'

  post    '/login',             to: 'sessions#create'
  post    '/games/new',         to: 'games#create'

  delete  '/logout',            to: 'sessions#destroy'

  resources :users
  resources :games
  
end
