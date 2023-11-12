class Room < ApplicationRecord
    #Relationships
    has_many :bookings

     # Validations
    validates :room_number, presence: true, uniqueness: true 
    validates :room_type, presence: true
    

      
end
