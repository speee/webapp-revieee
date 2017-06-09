class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks, unsigned: true do |t|
      t.string :arn, null: false
      t.string :repository, null: false
      t.integer :pr_number, unsigned: true, null: false

      t.timestamps
    end
    add_index :tasks, [:repository, :pr_number], unique: true
  end
end
