Rails.application.routes.draw do
  root :to => 'welcome#index'
  get '/stages/:id', to: 'stages#show', as: 'show_stage'
  get '/ranking', to: 'ranking#index'
  get '/my_bets', to: 'my_bets#index'
  get '/rules', to: 'rules#index'
  post '/my_bets', to: 'my_bets#save'
  devise_for :admins, ActiveAdmin::Devise.config
  devise_for :users
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    patch 'users' => 'devise/registrations#update', :as => 'user_registration'
  end
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
