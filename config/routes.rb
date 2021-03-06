Rails.application.routes.draw do
  scope 'history-editor' do
      root 'events#index'
      devise_for :users
      resources :citations
      resources :subjects
      resources :events
      # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  end
  devise_scope :user do
    root to: "events#index"
  end
end
