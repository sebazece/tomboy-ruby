class Book < ApplicationRecord
  belongs_to :user
  has_many :notes

  validates :name, presence: true, uniqueness: { scope: :user_id }

  scope :by_user, ->(user_id) { where('user_id = ?', user_id) }
end