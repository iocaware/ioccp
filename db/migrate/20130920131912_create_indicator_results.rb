class CreateIndicatorResults < ActiveRecord::Migration
  def change
    create_table :indicator_results do |t|
      t.integer :results_id
      t.string :indicator
      t.boolean :result

      t.timestamps
    end
  end
end
