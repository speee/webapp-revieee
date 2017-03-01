class AddTaskDefinitionIdToAndRemoveRepositoryFromTasks < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        change_table :tasks do |t|
          t.remove_index [:repository, :pr_number]
          t.remove :repository
          t.belongs_to :task_definition, foreign_key: true, unsigned: true, null: false, index: false, after: :arn
        end
        add_index :tasks, [:task_definition_id, :pr_number], unique: true
      end
      dir.down do
        remove_foreign_key :tasks, :task_definitions
        change_table :tasks do |t|
          t.remove_index [:task_definition_id, :pr_number]
          t.remove :task_definition_id
          t.string :repository, null: false, after: :arn
        end
        add_index :tasks, [:repository, :pr_number], unique: true
      end
    end
  end
end
