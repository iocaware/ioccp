require 'securerandom'

class AgentController < ApplicationController
	before_filter :authorize, :except => [:configure, :register, :get_public_key, :check]
	skip_before_filter :verify_authenticity_token, :except => [:settings, :save]

	def settings
		settings = AgentSetting.find(:all)
	end

	def save
	end

	def list
		type = params['type'].downcase
		if type.include?("disconnect") 
			type = "disconnected"
		end
		if !['connected', 'disconnected', 'never', 'all'].include?(type)
			render :text => "Cool story bro"
		else
			case type
			when "all"
				@agents = Agent.all
			when "connected"
				@agents = Agent.get_connected
			when "disconnected" 
				@agents = Agent.get_disconnected
			when "never"
				@agents = Agent.get_never
			end
		end
	end


	## API CALLS
	def agentnumbers
		output = Hash.new
		output['total'] = Agent.count
		output['connected'] = Agent.connected
		output['connected_1'] = Agent.connected_1day_ago
		output['connected_7'] = Agent.connected_7days_ago
		output['connected_30'] = Agent.connected_30days_ago
		output['connected_over_30'] = Agent.connected_over30
		output['never'] = Agent.connected_never
		render json: output
	end

	def osnumbers
		output = Array.new
		data = Agent.by_os
		data.each{|k,v| 
			tmp = Hash.new
			tmp['label'] = k
			tmp['data'] = v
			output << tmp
		}
		render json: output
	end

	def check
		agent = get_aid
		output = Hash.new
		a = Agent.find(:all, :conditions => {aid: agent}).first
		a.lastcheck = Time.now
		puts a.job_statuses.inspect
		a.save!
		output['jobs'] = Array.new
		a.jobs.each {|j|
			js = JobStatus.find(:all, :conditions => ['job_statuses.job_id = ? and job_statuses.agent_id = ?', j.id, Agent.find(:all, :conditions => {aid: agent}).first.id]).first
			if js.nil? or js.status == 0
				tmpHash = Hash.new
				tmpHash['jid'] = j.jid
				tmpHash['iocs'] = Array.new
				j = Job.find(j.id)
				j.iocs.each {|job| 
					tmpHash['iocs'] << job.iid
				}
				output['jobs'] << tmpHash
			end
		}
		render json: sign_json(get_aid, output)
	end

	def get_public_key
		agent = get_aid
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
		settings.each{|s|
			output[s.name] = s.value
		}
		render json: output
	end

	def register
		data = verify_hmac(get_aid, params['_json'])
		output = Hash.new
		output['success'] = false
		if data['os'].include?('Windows')
			target = 'Windows'
		elsif data['os'].include?('Mac')
			target = 'Mac'
		elsif data['os'].include?('Linux')
			target = 'Linux'
		else
			target = 'Other'
		end
		unless data.nil?
			begin
				# FIXME: check if dirty
				# FIXME: Add ip history so we can see what agents had what ip when
				# FIXME: Add users logged into the machines
				a = Agent.find(:all, :conditions => {aid: data['agent_id']}).first
				a.ip = data['ip']
				a.mac = data['mac']
				a.hostname = data['hostname']
				a.target = target
				a.os = data['os']
				a.osv = data['osv']
				a.save!
				output['success'] = true
			rescue => e
				output['success'] = false
				$utils.error(e.inspect + " " + caller.join("\r\n"))
			end
		end
		render json: sign_json(get_aid, output)
	end
	
end
