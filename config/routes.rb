Rails.application.routes.draw do
    resources :rooms
    resources :bookings
    resources :users
  
  # GET /active
    get 'active_bookings', to: 'bookings#active_bookings'

  # POST /signup
    post "/signup", to: "users#create"
  #POST /login
    post '/login', to: 'users#login'

  #POST /send_mail
  post 'bookings/send_email', to: 'bookings#personal_mail'

  #PATCH /booking/:id/approve
    patch "/bookings/:id/approve", to: 'bookings#approve'
  # PATCH /rooms/:id/available
    patch "/rooms/:id/available", to: "rooms#available"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

end
