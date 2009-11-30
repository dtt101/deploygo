class AddWeekendsColumn < ActiveRecord::Migration
  def self.up
    add_column :projects, :include_weekends, :boolean
  end

  def self.down
    remove_column :projects, :include_weekends
  end
end
