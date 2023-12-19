# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Create some users
User.create([
    { username: 'admin', email: 'admin@example.com', password: 'password', role: 1  }, # Admin user
    { username: 'user2', email: 'user2@example.com', password: 'password' },
    { username: 'user3', email: 'user3@example.com', password: 'password'},
    { username: 'Kymme', email: 'ikahinga@gmail.com', password: 'password', role: 1},
    { username: 'kahinga', email: 'kahingadev@gmail.com', password: 'password'},
  ])
  
  # Create some rooms
  Room.create([
    { room_number: '101', room_type: 'Single', description: 'A cozy single room', price: 100, capacity: 1 },
    { room_number: '201', room_type: 'Double', description: 'Spacious double room', price: 150, capacity: 2 },
    { room_number: '301', room_type: 'Suite', description: 'Luxurious suite', price: 250, capacity: 4 },
  ])
  
  # Create some bookings
  Booking.create([
    { start_date: Date.today, end_date: Date.today + 3, notes: 'First booking', user_id: 1, room_id: 1 },
    { start_date: Date.today + 5, end_date: Date.today + 7, notes: 'Second booking', user_id: 2, room_id: 2 },
    { start_date: Date.today - 2, end_date: Date.today, notes: 'Third booking', user_id: 1, room_id: 3 },
  ])

  Review.create([
    { content: "Very good atmosphere. Would come again", user_id:2},
    { content: "Good food from kitchen. ", user_id:3},
    { content: "Great stop over enroute to Ug", user_id:2}
  ])
  
  puts "Seed data created successfully"

  
  