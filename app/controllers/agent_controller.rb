class AgentController < ApplicationController
	before_filter :authorize, :except => [:configure]

	def settings
		settings = AgentSetting.find(:all)
	end

	def save
	end
	
	def configure
		settings = AgentSetting.find(:all)
		render json: settings
	end
end
