# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Create some users
User.create([
    { username: 'Kymme', email: 'ikahinga@gmail.com', password: 'password', role: 1},
    { username: 'kahinga', email: 'kahingadev@gmail.com', password: 'password'},
  ])
  
  # Create some rooms
  Room.create([
    { room_number: '211', room_type: 'Single', description: 'A cozy single room', price: 2200, capacity: 1 },
    { room_number: '212', room_type: 'Single', description: 'A cozy single room', price: 2200, capacity: 1 },
    { room_number: '213', room_type: 'Single', description: 'A cozy single room', price: 2200, capacity: 1 },
    { room_number: '214', room_type: 'Single', description: 'A cozy single room', price: 2200, capacity: 1 },
    { room_number: '215', room_type: 'Single', description: 'A cozy single room', price: 2200, capacity: 1 },
    { room_number: '216', room_type: 'Single', description: 'A cozy single room', price: 2200, capacity: 1 },
    { room_number: '217', room_type: 'Single', description: 'A cozy single room', price: 2200, capacity: 1 },
    { room_number: '218', room_type: 'Single', description: 'A cozy single room', price: 2200, capacity: 1 },
    { room_number: '311', room_type: 'Double', description: 'Spacious double room', price: 2700, capacity: 2 },
    { room_number: '312', room_type: 'Double', description: 'Spacious double room', price: 2700, capacity: 2 },
    { room_number: '313', room_type: 'Double', description: 'Spacious double room', price: 2700, capacity: 2 },
    { room_number: '314', room_type: 'Double', description: 'Spacious double room', price: 2700, capacity: 2 },
    { room_number: '315', room_type: 'Double', description: 'Spacious double room', price: 2700, capacity: 2 },
    { room_number: '316', room_type: 'Double', description: 'Spacious double room', price: 2700, capacity: 2 },
    { room_number: '317', room_type: 'Double', description: 'Spacious double room', price: 2700, capacity: 2 },
    { room_number: '318', room_type: 'Double', description: 'Spacious double room', price: 2700, capacity: 2 },
    { room_number: '412', room_type: 'Suite', description: 'Luxurious suite', price: 3700, capacity: 4 },
    { room_number: '413', room_type: 'Suite', description: 'Luxurious suite', price: 3700, capacity: 4 },
     { room_number: '414', room_type: 'Suite', description: 'Luxurious suite', price: 3700, capacity: 4 },
    
  ])
  

  
  puts "Seed data created successfully"

  
  