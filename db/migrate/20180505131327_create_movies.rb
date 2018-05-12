class CreateMovies < ActiveRecord::Migration[5.0]
  def change
    create_table :movies do |t|
      t.references :vtuber, foreign_key: true
      t.string :videoId
      t.string :title
      t.string :thumbnail
      t.datetime :publishedAt

      t.timestamps
    end
  end
end
