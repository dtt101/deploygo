class DropAuthColumns < ActiveRecord::Migration
  def self.up
    remove_column :organisations, :username
    remove_column :organisations, :hashed_password
    remove_column :organisations, :salt
  end

  def self.down
    add_column :organisations, :username, :string
    add_column :organisations, :hashed_password, :string
    add_column :organisations, :salt, :string
  end
end
