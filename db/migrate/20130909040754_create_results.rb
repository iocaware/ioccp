class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.boolean :pass
      t.integer :agent_id
      t.integer :job_id
      t.timestamps
    end

    add_index :results, :agent_id
    add_index :results, :job_id
  end
end
