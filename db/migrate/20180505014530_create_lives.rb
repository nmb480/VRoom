class CreateLives < ActiveRecord::Migration[5.0]
  def change
    create_table :lives do |t|
      t.references :vtuber, foreign_key: true
      t.string :liveId
      t.string :title
      t.string :thumbnail

      t.timestamps
    end
  end
end
