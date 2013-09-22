class Result < ActiveRecord::Base
	belongs_to :jobs
	belongs_to :agent
	has_many :indicator_results
	has_many :comments, :as => :commentable
  	attr_accessible :pass
end
