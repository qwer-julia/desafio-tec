Rails.application.routes.draw do
  root "challenges#index"
  mount ActiveStorageDB::Engine => "/active_storage_db"

  get "up" => "rails/health#show", as: :rails_health_check

  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create", as: :login_session
  delete "logout", to: "sessions#destroy", as: :logout

  get "convite/:token", to: "registrations#new", as: :signup
  post "convite/:token", to: "registrations#create"

  get "confirmacao/:token", to: "confirmations#show", as: :confirm_email

  resources :passwords, path: "senha", param: :token, only: [ :new, :create, :edit, :update ]

  resources :challenges, path: "desafios", only: [ :index, :show ] do
    resource :submission, path: "resposta", only: [ :create ]
  end

  get "placar", to: "scoreboard#show", as: :scoreboard
  get "placar/:id", to: "scoreboard#user", as: :scoreboard_user
  get "placar/:id/desafios/:challenge_id/entrega", to: "scoreboard#download", as: :scoreboard_download
  resource :avatar, path: "avatar", only: [ :show, :update ]
  get "regras", to: "rules#show", as: :rules
  get "calendario", to: "calendars#mine", as: :calendar
  get "calendario/equipe", to: "calendars#team", as: :team_calendar

  namespace :admin do
    resources :challenges, path: "desafios", only: [ :new, :create, :edit, :update ]
    resources :invitations, path: "convites", only: [ :new, :create ]
  end
end
