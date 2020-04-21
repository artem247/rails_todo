class CreateTodos < ActiveRecord::Migration[6.0]
  def change
    create_table :todos do |t|
      t.string :title
      t.boolean :done
      t.datetime :deadline
      t.references :todolist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
