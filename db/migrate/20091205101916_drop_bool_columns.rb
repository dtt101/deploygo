class DropBoolColumns < ActiveRecord::Migration
  def self.up
    remove_column :projects, :archive
    remove_column :organisations, :administrator
    remove_column :projects, :include_weekends
    remove_column :users, :read_only
  end

  def self.down
    add_column :projects, :archive, :boolean, :default => false
    add_column :organisations, :administrator, :boolean, :default => false
    add_column :projects, :include_weekends, :boolean, :default => false
    add_column :users, :read_only, :boolean, :default => false
  end
end
