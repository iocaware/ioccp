class Job < ActiveRecord::Base
	has_and_belongs_to_many :agents
	has_and_belongs_to_many :iocs
	has_many :results
	has_many :alerts
	has_many :comments, :as => :commentable
 	attr_accessible :end_on, :ioc, :name, :repeat, :start_on, :target

 	def self.running
 		self.find(:all, :conditions => ['jobs.start_on < ? and jobs.end_on > ? ',Time.now, Time.now])
 	end

 	def self.running_count
 		self.find(:all, :conditions => ['jobs.start_on < ? and jobs.end_on > ? ',Time.now, Time.now]).count
 	end
end
