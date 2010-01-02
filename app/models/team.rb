class Team < ActiveRecord::Base
  belongs_to :organisation
  has_and_belongs_to_many :resources
    
  default_scope :order => 'name'  
  
  validates_presence_of :name
  
end
