class Booking < ApplicationRecord
     #Relationships
     belongs_to :user
     belongs_to :room
     has_one :payment

     
end
