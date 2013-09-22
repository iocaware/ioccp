class MainController < ApplicationController
	before_filter :authorize

	def index
		@iocs = Ioc.find(:all)
		@targets = Agent.by_target
		@jobs = Job.running
		@jobs_total = Job.total
		@agents_connected = Agent.connected
		@agents_total = Agent.total
		@jobs_count = Job.running_count
		@alert_count = Alert.active_count
	end
end
