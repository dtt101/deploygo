class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string :name
      t.integer :organisation_id, :null => false  
      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
