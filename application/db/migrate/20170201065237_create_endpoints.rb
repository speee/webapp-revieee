class CreateEndpoints < ActiveRecord::Migration[5.0]
  def change
    create_table :endpoints, unsigned: true do |t|
      t.string :ip, limit: 15, null: false
      t.integer :port, limit: 2, unsigned: true, null: false
      t.belongs_to :task, foreign_key: true, unsigned: true, null: false

      t.timestamps
    end
  end
end
