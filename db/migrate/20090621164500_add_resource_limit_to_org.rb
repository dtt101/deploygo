class AddResourceLimitToOrg < ActiveRecord::Migration
  def self.up
    add_column :organisations, :resource_limit, :integer
  end

  def self.down
    remove_column :organisations, :resource_limit
  end
end
