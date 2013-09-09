class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :aid
      t.string :ip
      t.string :mac
      t.string :hostname
      t.string :target
      t.string :os
      t.string :osv
      t.timestamp :lastcheck
      t.timestamps
    end

    create_table :agents_jobs do | t |
      t.integer :agent_id
      t.integer :job_id
    end

    add_index(:agents_jobs, [:agent_id, :job_id])

  end
end
