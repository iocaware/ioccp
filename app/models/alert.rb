class Alert < ActiveRecord::Base
	belongs_to :result
  	attr_accessible :acknowleged, :actionplan, :reason, :urgent, :user_acknowledged

  	def self.count
  		self.find(:all).count
  	end
  	
end
