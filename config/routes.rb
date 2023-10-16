Rails.application.routes.draw do
    resources :rooms
    resources :bookings
    resources :users

  # POST /signup
    post "/signup", to: "users#create"
  #POST /login
    post '/login', to: 'users#login'

  #PATCH /booking/:id/approve
    patch "/bookings/:id/approve", to: 'bookings#approve'
  # PATCH /rooms/:id/available
    patch "/rooms/:id/available", to: "rooms#available"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

end
