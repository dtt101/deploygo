class AddDaysColumn < ActiveRecord::Migration
  def self.up
    add_column :projects, :days, :integer
  end

  def self.down
    remove_column :projects, :days
  end
end
