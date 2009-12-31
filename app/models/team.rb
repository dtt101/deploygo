class Team < ActiveRecord::Base
  belongs_to :organisation
  
  default_scope :order => 'name'  
  
  validates_presence_of :name
  
end
