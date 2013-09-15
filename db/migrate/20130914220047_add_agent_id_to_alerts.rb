class AddAgentIdToAlerts < ActiveRecord::Migration
  def change
  	add_column :agents, :agent_id, :string
  end
end
