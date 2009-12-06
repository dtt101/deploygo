
class Allocation < ActiveRecord::Base
  belongs_to :project
  belongs_to :resource
  
  validates_presence_of :resource_id, :project_id, :allocation_date
  #validates_uniqueness_of :allocation_date, :scope => [:resource_id]
  
  attr_accessor :date_from # create reader and writer methods for non-db attribute
  attr_accessor :date_to # create reader and writer methods for non-db attribute

end
