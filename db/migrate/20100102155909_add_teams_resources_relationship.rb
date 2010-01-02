class AddTeamsResourcesRelationship < ActiveRecord::Migration
  def self.up
    create_table :resources_teams, :id => false do |t| 
      t.integer :team_id
      t.integer :resource_id
    end
    # Indexes are important for performance if join tables grow big
    add_index :resources_teams, [:team_id, :resource_id], :unique => true
    add_index :resources_teams, :resource_id, :unique => false
  end

  def self.down
    drop_table :resources_teams
  end
end
