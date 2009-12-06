class Project < ActiveRecord::Base
  has_many :allocations, :dependent => :destroy
  has_many :resources, :through => :allocations
  belongs_to :organisation
  
  default_scope :order => 'name'
  named_scope :due_on_or_after, lambda {|date| { :conditions => ['due_date >= ?', date] } }
  named_scope :due_on_or_before, lambda {|date| { :conditions => ['due_date <= ?', date] } }
  named_scope :by_archive_status, lambda {|archived| { :conditions => ['archive = ?', archived] } }
  
  def name_with_days
    name + ' (' + days_info  + ')'
  end
  
  def days_info
    if days
      self.allocations.count.to_s + '/' + self.days.to_s
    else
      self.allocations.count.to_s
    end
  end 
  
end
