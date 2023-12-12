class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :booking
  validates :booking_id, presence: true, uniqueness: true
  validates :user_id, presence: true
end
