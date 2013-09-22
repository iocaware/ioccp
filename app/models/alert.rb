class Alert < ActiveRecord::Base
	belongs_to :result
	belongs_to :job
  belongs_to :agent
  	attr_accessible :acknowleged, :actionplan, :reason, :urgent, :user_acknowledged

  	def self.count
  		self.find(:all).count
  	end
  	def self.active_count
      self.find(:all, :conditions => {acknowleged: false}).count
    end

  	def self.active
  		self.find(:all, :conditions => {acknowleged: false})
  	end

    def self.acknowleged
      self.find(:all, :conditions => {acknowleged: true})
    end
end
