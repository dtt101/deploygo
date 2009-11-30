class AddReadonlyColumn < ActiveRecord::Migration
  def self.up
    add_column :users, :read_only, :boolean, :default => false
  end

  def self.down
    remove_column :users, :read_only
  end
end
