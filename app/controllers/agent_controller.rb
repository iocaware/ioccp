require 'securerandom'

class AgentController < ApplicationController
	before_filter :authorize, :except => [:configure, :register, :get_public_key]
	skip_before_filter :verify_authenticity_token, :except => [:settings, :save]

	def settings
		settings = AgentSetting.find(:all)
	end

	def save
	end

	## API CALLS
	def agentnumbers
	end

	def get_public_key
		agent = params[:agent_id]
		existing = Agent.exists?(aid: agent)
		if existing
			a = Agent.find(:all, :conditions => {aid: agent}).first
			key = a.hmac
		else
			key = Base64.encode64(SecureRandom.uuid + SecureRandom.uuid)
			a = Agent.new
			a.aid = agent
			a.hmac = key
			a.save!
		end
		render text: key
	end

	def configure
		settings = AgentSetting.find(:all)
		output = Hash.new
		output['success'] = true
		render json: output
	end

	def register
		data = verify_hmac(get_aid, params['_json'])
		output = Hash.new
		output['success'] = false
		unless data.nil?
			begin
				# FIXME: check if dirty
				# FIXME: Add ip history so we can see what agents had what ip when
				# FIXME: Add users logged into the machines
				a = Agent.find(:all, :conditions => {aid: data['agent_id']}).first
				a.ip = data['ip']
				a.mac = data['mac']
				a.hostname = data['hostname']
				a.target = ''
				a.os = data['os']
				a.osv = data['osv']
				a.save!
				output['success'] = true
			rescue => e
				output['success'] = false
				$utils.error(e.inspect + " " + caller.join("\r\n"))
			end
		end
		output = sign_json(get_aid, output)
		render json: output
	end
private

	def get_aid
		params[:agent_id]
	end
end
