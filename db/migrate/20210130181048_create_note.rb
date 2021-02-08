class CreateNote < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.string :title
      t.text :body
      t.belongs_to :book, null: true
      t.belongs_to :user, foreign_key: true
    end
  end
end
