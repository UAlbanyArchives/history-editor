Rails.application.routes.draw do
  devise_for :users
  resources :citations
  resources :subjects
  resources :events
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
  	root to: "events#index"
  end
end
