class CreateAllocations < ActiveRecord::Migration
  def self.up
    create_table :allocations do |t|
      t.integer :resource_id, :null => false
      t.integer :project_id, :null => false
      t.datetime :allocation_date      
      t.timestamps
    end
  end

  def self.down
    drop_table :allocations
  end
end
