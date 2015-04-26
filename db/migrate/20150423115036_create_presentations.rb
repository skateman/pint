class CreatePresentations < ActiveRecord::Migration
  def change
    create_table :presentations do |t|
      t.string :title
      t.text :description
      t.string :pdf
      t.integer :slides
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
