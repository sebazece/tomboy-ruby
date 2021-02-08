class CreateBook < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :name
      t.boolean :global_book
      t.belongs_to :user, foreign_key: true
    end
  end
end
