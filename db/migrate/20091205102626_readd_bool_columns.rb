class ReaddBoolColumns < ActiveRecord::Migration
  def self.up
    add_column :projects, :archive, :boolean, :default => false
    add_column :organisations, :administrator, :boolean, :default => false
    add_column :projects, :include_weekends, :boolean, :default => false
    add_column :users, :read_only, :boolean, :default => false
  end

  def self.down
  end
end
