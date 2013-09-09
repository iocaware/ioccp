class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.timestamp :start_on
      t.timestamp :end_on
      t.string :target
      t.string :ioc
      t.string :repeat

      t.timestamps
    end
  end
end
