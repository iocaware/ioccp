class Agent < ActiveRecord::Base
	has_and_belongs_to_many :jobs
	has_many :alerts
  has_many :job_statuses
	has_many :comments, :as => :commentable
  	attr_accessible :aid, :hostname, :ip, :lastcheck, :mac, :os, :osv, :target

    def self.total
      self.find(:all).count
    end
    
    def connected?
      check =  AgentSetting.find(:all, :conditions => {name: 'check_time'}).first.value.to_i.minutes.ago+1
      if lastcheck > check
        return true
      else
        return false
      end
    end

    def self.get_connected
      self.find(:all, :conditions => ['agents.lastcheck > ?', AgentSetting.find(:all, :conditions => {name: 'check_time'}).first.value.to_i.minutes.ago+3])
    end

    def self.get_disconnected
      self.find(:all, :conditions => ['agents.lastcheck < ?', AgentSetting.find(:all, :conditions => {name: 'check_time'}).first.value.to_i.minutes.ago+3])
    end

    def self.get_never
      self.find(:all, :conditions => ['agents.lastcheck = ?', nil])
    end
    
  	def self.connected
  		self.find(:all, :conditions => ['agents.lastcheck > ?', AgentSetting.find(:all, :conditions => {name: 'check_time'}).first.value.to_i.minutes.ago+3]).count
  	end

  	def self.connected_1day_ago
  		self.find(:all, :conditions => ['agents.lastcheck < ? and agents.lastcheck > ? ', AgentSetting.find(:all, :conditions => {name: 'check_time'}).first.value.to_i.minutes.ago, 1.days.ago]).count
  	end

  	def self.connected_7days_ago
  		self.find(:all, :conditions => ['agents.lastcheck < ? and agents.lastcheck > ? ', 1.days.ago, 7.days.ago]).count
  	end

  	def self.connected_30days_ago
  		self.find(:all, :conditions => ['agents.lastcheck < ? and agents.lastcheck > ? ', 7.days.ago, 30.days.ago]).count
  	end

    def self.connected_over30
      self.find(:all, :conditions => ['agents.lastcheck < ? and agents.lastcheck > ? ', 30.days.ago, 90.days.ago]).count
    end


    def self.connected_never
      self.find(:all, :conditions => {lastcheck: nil}).count
    end

    def self.by_os
      self.count(:group => :os)
    end

    def self.by_target
      self.count(:group => :target)
    end

end
