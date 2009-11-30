class AddProjectDuedate < ActiveRecord::Migration
  def self.up
    add_column :projects, :due_date, :datetime
  end

  def self.down
    drop_column :projects, :due_date
  end
end
