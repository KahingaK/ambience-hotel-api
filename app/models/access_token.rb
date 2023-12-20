class AccessToken < ApplicationRecord
    validates :token, presence: true
end

