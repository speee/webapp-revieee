class CreateTaskDefinitions < ActiveRecord::Migration[5.0]
  def change
    create_table :task_definitions, unsigned: true do |t|
      t.string :repository, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :task_definitions, :repository, unique: true
  end
end
