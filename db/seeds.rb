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
    { room_number: '101', room_type: 'Single', description: 'A cozy single room', price: 100, capacity: 1 },
    { room_number: '102', room_type: 'Single', description: 'A cozy single room', price: 100, capacity: 1 },
    { room_number: '103', room_type: 'Single', description: 'A cozy single room', price: 100, capacity: 1 },
    { room_number: '104', room_type: 'Single', description: 'A cozy single room', price: 100, capacity: 1 },
    { room_number: '105', room_type: 'Single', description: 'A cozy single room', price: 100, capacity: 1 },
    { room_number: '106', room_type: 'Single', description: 'A cozy single room', price: 100, capacity: 1 },
    { room_number: '107', room_type: 'Single', description: 'A cozy single room', price: 100, capacity: 1 },
    { room_number: '108', room_type: 'Single', description: 'A cozy single room', price: 100, capacity: 1 },
    { room_number: '201', room_type: 'Double', description: 'Spacious double room', price: 150, capacity: 2 },
    { room_number: '202', room_type: 'Double', description: 'Spacious double room', price: 150, capacity: 2 },
    { room_number: '203', room_type: 'Double', description: 'Spacious double room', price: 150, capacity: 2 },
    { room_number: '204', room_type: 'Double', description: 'Spacious double room', price: 150, capacity: 2 },
    { room_number: '205', room_type: 'Double', description: 'Spacious double room', price: 150, capacity: 2 },
    { room_number: '206', room_type: 'Double', description: 'Spacious double room', price: 150, capacity: 2 },
    { room_number: '207', room_type: 'Double', description: 'Spacious double room', price: 150, capacity: 2 },
    { room_number: '208', room_type: 'Double', description: 'Spacious double room', price: 150, capacity: 2 },
    { room_number: '301', room_type: 'Suite', description: 'Luxurious suite', price: 250, capacity: 4 },
    { room_number: '302', room_type: 'Suite', description: 'Luxurious suite', price: 250, capacity: 4 },
     { room_number: '303', room_type: 'Suite', description: 'Luxurious suite', price: 250, capacity: 4 },
    
  ])
  

  
  puts "Seed data created successfully"

  
  