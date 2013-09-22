class IndicatorResult < ActiveRecord::Base
	self.table_name =  "indicator_results"
	belongs_to :jobs
	belongs_to :agents

  attr_accessible :agent_id, :indicator, :result
end
