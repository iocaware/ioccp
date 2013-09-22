class AddAgentIdToAlerts2 < ActiveRecord::Migration
  def change
    add_column :alerts, :agent_id, :integer
  end
end
