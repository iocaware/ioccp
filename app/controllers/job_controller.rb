require 'securerandom'

class Hash
  def deep_find(key)
    result = []
    result << self[key]
    self.values.each do |hash_value|
      values = [hash_value] unless hash_value.is_a? Array
      values.each do |value|
        result += value.deep_find(key) if value.is_a? Hash
      end
    end
    result.compact
  end
end

class JobController < ApplicationController
	before_filter :authorize, :except => [:confirm ,:status, :report]
	skip_before_filter :verify_authenticity_token, :except => [:add]

	def add
		iocs = params['job_ioc']
		targets = params['target']
		job_name = params['job_name']
		begin
			j = Job.create
			j.jid = SecureRandom.uuid
			j.name = job_name
			j.start_on = Time.now
			j.end_on = Time.now + 1.week
			j.target = targets.join(",")
			j.repeat = params['repeat']
			targets.each {|t|
				a = Agent.find(:all, :conditions => {target: t})
				a.each { |agent |
					j.agents += [agent]
					js = JobStatus.new
					js.job_id = j.id
					js.agent_id = agent.id
					js.status = 0
					js.save
				}
			}
			iocs.each { |i|
				j.iocs += [Ioc.find(:all, :conditions => {iid: i}).first]
			}
			j.save!
			redirect_to root_url, alert: "Job Added"
		rescue => e
			puts e.inspect
			redirect_to root_url, alert: "Failed to add job"
		end
	end

	def delete
		jobid = params['job']['jid']
		begin
			Job.where(:jid => jobid).destroy_all
			redirect_to root_url, alert: "Successfully removed Job"
		rescue
			redirect_to root_url, alert: "There was a problem removing the Job"
		end
	end

	def status
		jobid = params['job_id']
		job = Job.find(:all, :conditions => {jid: jobid}).first
		output = Hash.new
		output['total_agents'] = job.agents.count
		output['total_in_process'] = JobStatus.find(:all, :conditions => ['job_statuses.job_id = ? and job_statuses.status = 1 ', job.id]).count
		output['total_completed'] = JobStatus.find(:all, :conditions => ['job_statuses.job_id = ? and job_statuses.status = 2 ', job.id]).count
		output['percentage'] = ((output['total_completed'].to_f/output['total_agents'].to_f)*100).to_i
		if output['percentage'] == 100
			job.end_on = Time.now
			job.save!
		end
		render json: output
	end

	def confirm
		output = Hash.new
		jobid = params["job_id"]
		agent = params["agent_id"]
		j = Job.find(:all, :conditions => {jid: jobid}).first.id
		a =  Agent.find(:all, :conditions => {aid: agent}).first.id
		js = JobStatus.where(job_id: a, agent_id: j).exists?
		if js
			js = JobStatus.where(job_id: a, agent_id: j).first
			js.status = 1 # started
			js.save!
		end
		render json: sign_json(get_aid, output)
	end

	def report
		output = Hash.new
		output['status'] = "Complete"
		jobid = params["job_id"]
		agent = params["agent_id"]
		ioc = params["ioc_id"]
		data = verify_hmac(get_aid, params['_json'])
		a =  Agent.find(:all, :conditions => {aid: agent}).first.id
		j = Job.find(:all, :conditions => {jid: jobid}).first.id
		js = JobStatus.where(job_id: j, agent_id: a).exists?
		if js
			js = JobStatus.where(job_id: j, agent_id: a).first
			js.status = 2 # completed
			js.save!
		end
		#i = Hash.from_xml(Base64.decode64(Ioc.find(:all, :conditions => {iid: ioc}).first.content))
		results = data.deep_find('status')
		alert = results.any? {|t| t == true }
		puts alert
		r = Result.new
		r.agent_id = a
		r.job_id = j
		r.ioc_id = Ioc.find(:all, :conditions => {iid: ioc}).first.id
		r.pass = alert
		data.each { |k,v| 
			if k != "status"
				if data[k].respond_to?(:each) 
					is = r.indicator_results.new
					is.indicator = k
					is.result = data[k]['status']
					is.save
					data[k].each { |a,b| 
						is = r.indicator_results.new
						is.indicator = a
						is.result = b
						is.save
					}
				else
					is = r.indicator_results.new
					is.indicator = k
					is.result = v
					is.save
				end
			end
		}
		r.save
		if alert
			#save alert
			a = Alert.new
			a.urgent = true
			a.acknowleged = false
			a.user_acknowledged = 0
			a.reason = Ioc.find(:all, :conditions => {iid: ioc}).first.name + " Triggered Positive Alert"
			a.actionplan = ""
			a.results_id = r.id
			a.job_id = r.job_id
			a.agent_id = r.agent_id
			a.save
		end
		render json: sign_json(get_aid, output)
	end

	def active
		@alerts = Alert.active
		@old = Alert.acknowleged
	end

	def ack_alert
		alert = params['alert']['id']
		a = Alert.find(alert)
		a.acknowleged = true
	 	a.save
	 	redirect_to '/alerts/active', alert: "Successfully acknowleged the alert"
	 end

	 def delete_alert
		alert = params['alert']['id']
		begin
			Alert.where(:id => alert).destroy_all
			redirect_to '/alerts/active', alert: "Successfully removed Alert"
		rescue
			redirect_to '/alerts/active', alert: "There was a problem removing the Alert"
		end
	end

	def detail
		jid = params["job_id"]
		@job = Job.find(:all, :conditions => {jid: jid}).first
		job_status = @job.job_statuses.count(:group => :status)
		puts job_status.inspect
		@js = Hash.new
		@js['Pending'] = 0
		@js['Running'] = 0
		@js['Complete'] = 0
		job_status.each { |k,v|
			puts "Key: " + k.to_s + " Value: " + v.to_s
			case k
			when 1
				@js['Running'] = v
			when 2
				@js['Complete'] = v
			else @js['Pending'] = v
			end
		}
	end

	def list
		@jobs = Job.all
	end
end