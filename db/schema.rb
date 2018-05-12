# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180506024344) do

  create_table "channel_statistics", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "vtuber_id"
    t.integer  "viewCount"
    t.integer  "subscriberCount"
    t.integer  "videoCount"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["vtuber_id"], name: "index_channel_statistics_on_vtuber_id", using: :btree
  end

  create_table "channel_twitters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "vtuber_id"
    t.string   "screen_name"
    t.string   "hashtag"
    t.string   "regist_type", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["vtuber_id"], name: "index_channel_twitters_on_vtuber_id", using: :btree
  end

  create_table "lives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "vtuber_id"
    t.string   "liveId"
    t.string   "title"
    t.string   "thumbnail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vtuber_id"], name: "index_lives_on_vtuber_id", using: :btree
  end

  create_table "movies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "vtuber_id"
    t.string   "videoId"
    t.string   "title"
    t.string   "thumbnail"
    t.datetime "publishedAt"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["videoId"], name: "videoId", unique: true, using: :btree
    t.index ["vtuber_id"], name: "index_movies_on_vtuber_id", using: :btree
  end

  create_table "vtubers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "channelId",    null: false
    t.string   "belongto"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "channelTitle"
    t.string   "thumbnail"
    t.index ["channelId"], name: "channelid", unique: true, using: :btree
  end

  add_foreign_key "channel_statistics", "vtubers"
  add_foreign_key "channel_twitters", "vtubers"
  add_foreign_key "lives", "vtubers"
  add_foreign_key "movies", "vtubers"
end
