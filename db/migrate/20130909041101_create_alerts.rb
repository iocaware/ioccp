class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.boolean :urgent
      t.boolean :acknowleged
      t.integer :user_acknowledged
      t.string :reason
      t.text :actionplan
      t.integer :results_id
      t.timestamps
    end

    add_index :alerts, :results_id
    add_index :alerts, :acknowleged
    add_index :alerts, :urgent
    
  end
end
