class CreateVtubers < ActiveRecord::Migration[5.0]
  def change
    create_table :vtubers do |t|
      t.string :name, null: false
      t.string :channelId, null: false, unique: true
      t.string :channelTitle 
      t.string :thumbnail
      t.text :description 
      t.datetime :publishedAt
      t.string :belongto

      t.timestamps
    end
  end
end
