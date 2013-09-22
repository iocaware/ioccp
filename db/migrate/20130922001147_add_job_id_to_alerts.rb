class AddJobIdToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :job_id, :integer
  end
end
