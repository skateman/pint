class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :number
      t.references :session, index: true, foreign_key: true
      t.references :question, index: true, foreign_key: true
      t.string :sessid

      t.timestamps null: false
    end
  end
end
