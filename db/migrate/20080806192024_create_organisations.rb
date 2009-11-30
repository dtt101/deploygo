class CreateOrganisations < ActiveRecord::Migration
  def self.up
    create_table :organisations do |t|
      t.string :name
      t.string :username
      t.string :hashed_password
      t.string :salt
      t.boolean :administrator
      t.timestamps
    end
  end

  def self.down
    drop_table :organisations
  end
end
