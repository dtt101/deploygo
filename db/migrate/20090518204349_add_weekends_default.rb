class AddWeekendsDefault < ActiveRecord::Migration
  def self.up
    change_column :projects, :include_weekends, :boolean, :default => false
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
