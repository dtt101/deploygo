class AddArchiveColumn < ActiveRecord::Migration
  def self.up
    add_column :projects, :archive, :boolean, :default => false
  end

  def self.down
    remove_column :projects, :archive
  end
end
