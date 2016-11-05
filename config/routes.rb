Rails.application.routes.draw do
  resources :notes
  root to:    'visitors#index'
  
  devise_for  :users
  resources   :users
  resources   :tasks
end
