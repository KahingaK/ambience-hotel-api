Rails.application.routes.draw do
  resources :restaurants
  resources :posts

    resources :rooms
    resources :bookings
    resources :users
    resources :reviews, only: [:index, :create, :destroy]
  
  # GET /active
    get '/active_bookings', to: 'bookings#active_bookings'

  # POST /signup
    post "/signup", to: "users#create"
  #POST /login
    post '/login', to: 'users#login'

  #POST /send_mail
  post '/bookings/send_email', to: 'bookings#personal_mail'

  #PATCH /booking/:id/approve
    patch "/bookings/:id/approve", to: 'bookings#approve'
  # PATCH /rooms/:id/available
    patch "/rooms/:id/available", to: "rooms#available"

    #POST bookings
    post "/bookings_new", to: "bookings#create_new"

    get '/reset_password/:reset_token', to: 'password_reset#edit', as: 'edit_password_reset'
    post '/reset_password',to: 'password_reset#create'
    put '/update_password/:reset_token', to: 'password_reset#update'
  #payments
  # post '/stkpush', to: 'payments#stkpush'
  # post '/stkquery', to: 'payments#stkquery'
  # post '/mpesa_callback', to: 'payments#callback'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

end
