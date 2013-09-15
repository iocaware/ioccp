require 'securerandom'
class JobController < ApplicationController
	before_filter :authorize, :except => [:confirm ,:status]
	skip_before_filter :verify_authenticity_token, :except => [:add]

	def add
		iocs = params['job_ioc']
		targets = params['target']
		job_name = params['job_name']
		begin
			j = Job.new
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
		puts current_user
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
		output['total_in_process'] = JobStatus.find(:all, :conditions => ['job_statuses.job_id = ? and job_statuses.status = 1 ', jobid]).count
		output['total_completed'] = JobStatus.find(:all, :conditions => ['job_statuses.job_id = ? and job_statuses.status = 2 ', jobid]).count
		output['percentage'] = output['total_completed'] / output['total_agents'] * 100
		render json: output
	end

	def confirm
		output = Hash.new
		jobid = params["job_id"]
		agent = params["agent_id"]
		js = JobStatus.where(job_id: jobid, agent_id: agent).exists?
		if js
			js = JobStatus.where(job_id: jobid, agent_id: agent).first
			js.status = 1 # started
			js.save!
		else
			js = JobStatus.new
			js.job_id = jobid
			js.agent_id = agent
			js.status = 1
			js.save!
		end
		render json: sign_json(get_aid, output)
	end
end