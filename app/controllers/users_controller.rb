class UsersController < ApplicationController

	def new
		@user = User.new
	end

	def list
		@users = User.find(:all)
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			render "list"
		else
			render "new"
		end
	end
end
