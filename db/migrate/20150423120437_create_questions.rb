class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :slide
      t.string :body
      t.string :choices, array: true, default: []
      t.references :presentation, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
