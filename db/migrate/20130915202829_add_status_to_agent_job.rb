class AddStatusToAgentJob < ActiveRecord::Migration
  def change
  	add_column :agents_jobs, :status, :integer
  end
end
