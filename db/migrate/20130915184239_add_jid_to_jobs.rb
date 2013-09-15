class AddJidToJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :jid, :string 
  end
end
