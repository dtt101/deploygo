
class Organisation < ActiveRecord::Base

  has_many :projects, :dependent => :destroy
  has_many :resources, :dependent => :destroy
  has_many :users, :dependent => :destroy
  has_many :teams, :dependent => :destroy
  
  validates_presence_of :name
  
  def after_destroy
    if Organisation.count.zero?
      raise "Can't delete last organisation"
    end
  end

end
