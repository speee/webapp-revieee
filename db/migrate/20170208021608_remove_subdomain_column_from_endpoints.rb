class RemoveSubdomainColumnFromEndpoints < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        remove_column :endpoints, :subdomain
      end
      dir.down do
        add_column :endpoints, :subdomain, limit: 32, null: false
        add_index :endpoints, :subdomain, unique: true
      end
    end
  end
end
