class Job < ActiveRecord::Base
	has_and_belongs_to_many :agents
	has_many :results
	has_many :alerts
	has_many :comments, :as => :commentable
 	attr_accessible :end_on, :ioc, :name, :repeat, :start_on, :target
end
