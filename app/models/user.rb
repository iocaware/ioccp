class User < ActiveRecord::Base
	has_many :comments
  	attr_accessible :email, :first_name, :isadmin, :last_name, :read_only, :username, :password, :password_confirmation
  	has_secure_password
  	validates_presence_of :password, :on => :create
  	validates_uniqueness_of :email
  	validates_uniqueness_of :username
end
