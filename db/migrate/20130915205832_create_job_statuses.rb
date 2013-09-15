class CreateJobStatuses < ActiveRecord::Migration
  def change
    create_table :job_statuses do |t|
      t.string :job_id
      t.string :agent_id
      t.integer :status

      t.timestamps
    end
  end
end
