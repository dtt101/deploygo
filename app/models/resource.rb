class Resource < ActiveRecord::Base
  has_many :allocations, :dependent => :destroy
  has_many :projects, :through => :allocations
  has_and_belongs_to_many :teams
  belongs_to :organisation
  
  default_scope :order => 'name'  
  
  def initials
    names = name.split(" ")
    inits = ""
    names.each {|bit| 
      inits += bit.first
    }
    inits
  end
end
