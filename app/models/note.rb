class Note < ApplicationRecord
  belongs_to :book, optional: true
  belongs_to :user

  validates :title, uniqueness: { scope: %I[user_id book_id] }
  validates :body, presence: true

  scope :by_user, ->(user_id) { where(user_id: user_id) }
end