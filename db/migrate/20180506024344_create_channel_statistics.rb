class CreateChannelStatistics < ActiveRecord::Migration[5.0]
  def change
    create_table :channel_statistics do |t|
      t.references :vtuber, foreign_key: true
      t.integer :viewCount
      t.integer :subscriberCount
      t.integer :videoCount

      t.timestamps
    end
  end
end
