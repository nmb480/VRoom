Rails.application.routes.draw do
    root to: 'toppages#index'
    
    resources :channels, only: [:show]
    resources :registrations, only: [:index, :new, :create]
    resources :channel_twitters, only: [:new, :create, :destroy]
    
end
