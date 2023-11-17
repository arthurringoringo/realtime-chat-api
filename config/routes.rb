Rails.application.routes.draw do
  resources :chat_rooms
  resources :users

  get "chat_room/:id/messages", to: "messages#index"
  get "user/:id/chat_room", to: "chat_rooms#users_room"
  post "messages/", to: "messages#create"
  post "chat_as/", to: "users#as_user"
  post "chat_rooms/join/:id", to: "chat_rooms#join"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  mount ActionCable.server => "/cable"
end
