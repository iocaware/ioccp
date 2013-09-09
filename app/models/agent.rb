class Agent < ActiveRecord::Base
	has_and_belongs_to_many :jobs
	has_many :alerts
	has_many :comments, :as => :commentable
  	attr_accessible :aid, :hostname, :ip, :lastcheck, :mac, :os, :osv, :target
end
