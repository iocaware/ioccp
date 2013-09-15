class CreateIocs < ActiveRecord::Migration
  def change
    create_table :iocs do |t|
      t.string :iid
      t.string :name
      t.string :description
      t.string :author
      t.string :content
      t.string :path
      t.string :publicpath
      t.string :source
      t.timestamps
    end
  end
end
