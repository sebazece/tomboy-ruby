class Note < ApplicationRecord
  belongs_to :book, optional: true
  belongs_to :user

  validates :title, uniqueness: { scope: %I[user_id book_id] }
  validates :body, presence: true

end