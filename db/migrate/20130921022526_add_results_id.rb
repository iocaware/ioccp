class AddResultsId < ActiveRecord::Migration
  def up
  	add_column :indicator_results, :result_id, :integer
  end

  def down
  	
  end
end
