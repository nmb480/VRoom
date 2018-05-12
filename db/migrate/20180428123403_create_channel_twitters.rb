class CreateChannelTwitters < ActiveRecord::Migration[5.0]
  def change
    create_table :channel_twitters do |t|
      t.references :vtuber, foreign_key: true
      t.string :screen_name
      t.string :hashtag
      t.string :regist_type, null: false

      t.timestamps
    end
  end
end
