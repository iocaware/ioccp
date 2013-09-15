class ChangeIocJob < ActiveRecord::Migration
  def up
  	remove_column :jobs, :ioc

  	create_table :iocs_jobs do | t |
      t.integer :ioc_id
      t.integer :job_id
    end

    add_index(:iocs_jobs, [:job_id, :ioc_id])
  end

  def down
  end
end
