class CreateAgentSettings < ActiveRecord::Migration
  def change
    create_table :agent_settings do |t|
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
