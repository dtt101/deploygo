require 'digest/sha1'

class User < ActiveRecord::Base
  
  belongs_to :organisation
  
  validates_presence_of :email, :name
  validates_uniqueness_of :email
  validates_presence_of :password, :on => :create
  validates_length_of :password, :in => 6..20, :if => :password
  
  default_scope :order => 'name'  
  
  attr_accessor :password_confirmation
  validates_confirmation_of :password
  
  def self.authenticate(email, password)
    user = self.find_by_email(email)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end
  
  def validate
    errors.add_to_base("Missing password") if hashed_password.blank?
  end
  
  # password is a virtual attribute
  def password
    @password
  end
  
  def password=(pwd)
    @password = pwd
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end
  
  def after_destroy
    if User.count.zero?
      raise "Can't delete last user"
    end
  end
  
  private
  
  def self.encrypted_password(password, salt)
    string_to_hash = password + "curzon" + salt # 'curzon' makes it harder to guess
    Digest::SHA1.hexdigest(string_to_hash)
  end
  
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
end
