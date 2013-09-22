require "signed_json"

class ApplicationController < ActionController::Base
  protect_from_forgery

private

	def verify_hmac(aid, data)
		k = get_agent_hmac_key(aid)
		s = SignedJson::Signer.new(k)
		begin
			return JSON.parse(s.decode(data.to_json))
		rescue => e
			puts "Could not verify signature"
			nil
		end
	end

	def sign_json(aid, data)
		k = get_agent_hmac_key(aid)
		s = SignedJson::Signer.new(k)
		begin
			return JSON.parse(s.encode(data.to_json))
		rescue => e
			nil
		end
	end

	def get_agent_hmac_key(aid)
		a = Agent.find(:all, :conditions => {aid: aid}).first
		return a.hmac
	end
	helper_method :current_user

	def current_user
		@current_user || User.find(session[:user_id]) if session[:user_id]
	end

	

	def authorize
		redirect_to login_url, alert: "Not authorized" if current_user.nil?
	end

	def get_aid
		params[:agent_id]
	end
end