Rails.application.routes.draw do
  root  'pages#intro'

  get   '/challenges',      to: 'question#index',     as: 'challenges'
  get   '/statics',         to: 'pages#statics',      as: 'statics'
  post  '/challenges/:id',  to: 'question#show',      as: 'challenge'
  post  '/answer/:id',      to: 'question#answer',    as: 'answer'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, skip: [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    patch 'users/:id' => 'devise/registrations#update', :as => 'user_registration'
  end
end
