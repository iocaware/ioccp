require "base64"
class IocController < ApplicationController
	before_filter :authorize, :except => [:get]
	skip_before_filter :verify_authenticity_token, :except => [:add]

	def add
		begin
			data = Hash.from_xml(params['ioc'])
		rescue
			redirect_to root_url, alert: "Invalid OpenIOC Document"
		end
		begin
			ioc = Ioc.exists?(iid: data['ioc']['id'])
			if ioc
				redirect_to root_url, alert: "This IOC alread exists in the IOC Catalog"
			else
				ioc = Ioc.new
				ioc.iid = data['ioc']['id']
				ioc.name = data['ioc']['short_description']
				ioc.description = data['ioc']['description']
				ioc.author = data['ioc']['authored_by']
				ioc.content = Base64.encode64(params['ioc'])
				ioc.source = "Manual"
				ioc.save!
				redirect_to root_url, alert: "IOC Added"
			end
		rescue => e
			puts e.inspect
			puts caller.join("\n")
			redirect_to root_url, alert: "There was a problem adding the IOC Document"
		end
	end

	def delete
		iocid = params['ioc']['iid']
		puts iocid
		begin
			Ioc.where(:iid => iocid).destroy_all
			redirect_to root_url, alert: "Successfully removed IOC Document from the Catalog"
		rescue
			redirect_to root_url, alert: "There was a problem removing the IOC Document from the Catalog"
		end
	end

	def get
		iocid = params["ioc_id"]
		ioc = Ioc.find(:all, :conditions => {iid: iocid}).first
		render :xml => Base64.decode64(ioc.content)
	end
end