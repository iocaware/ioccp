class JobStatus < ActiveRecord::Base
  attr_accessible :aid, :jid, :status
  belongs_to :agent
  belongs_to :job
end
