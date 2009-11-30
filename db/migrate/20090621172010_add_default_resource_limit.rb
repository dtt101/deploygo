class AddDefaultResourceLimit < ActiveRecord::Migration
  def self.up
    change_column :organisations, :resource_limit, :integer, :default => 0
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
