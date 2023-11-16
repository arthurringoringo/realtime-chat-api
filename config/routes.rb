Rails.application.routes.draw do
  resources :messages
  resources :chat_rooms
  resources :users

  post "chat_as/", to: "users#as_user"
  post "chat_rooms/join/:id", to: "chat_rooms#join"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  mount ActionCable.server => "/cable"
end
