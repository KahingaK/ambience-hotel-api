class User < ApplicationRecord
    #Relationships
    has_many :bookings
    has_many :reviews
    has_many :payments

    # Helper method to encrypt password
     has_secure_password

    # roles
     enum role: [:guest, :admin, :staff]

    # Validations
    validates :email, presence: true, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP} # checks if the email attribute of a model matches a valid email format
    validates :username, presence: true, uniqueness: true
    validates :password, length: { minimum: 6}, if: -> {new_record? || !password.nil?}
            
    # Method to allow easy access of a user's role
    def user_type
        User.roles.key(self[:roles])
    end
    
    
end
