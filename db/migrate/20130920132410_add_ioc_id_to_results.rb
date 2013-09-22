class AddIocIdToResults < ActiveRecord::Migration
  def change
  	add_column :results, :ioc_id, :string
  end
end
