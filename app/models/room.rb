class Room < ApplicationRecord
    #Relationships
    has_many :bookings 
end
