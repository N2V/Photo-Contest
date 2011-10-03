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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110730235705) do

  create_table "contest_configs", :force => true do |t|
    t.integer  "contest_id"
    t.string   "lang"
    t.text     "welcome_note"
    t.text     "prizes"
    t.text     "entry_format"
    t.text     "inappropriate_content"
    t.text     "winning_eligibility"
    t.text     "upload_hint"
    t.text     "email_body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "contest_configs", ["contest_id", "lang"], :name => "index_contest_configs_on_contest_id_and_lang", :unique => true

  create_table "contests", :force => true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "admins",                                           :null => false
    t.string   "page_id",                                          :null => false
    t.integer  "user_id",                                          :null => false
    t.text     "page_link"
    t.string   "notifications_sender_email"
    t.string   "notifications_receivers_emails"
    t.string   "state"
    t.integer  "prizes_num",                     :default => 1,    :null => false
    t.integer  "languages",                      :default => 1,    :null => false
    t.string   "default_language",               :default => "en", :null => false
    t.integer  "flags",                          :default => 0,    :null => false
  end

  create_table "images", :force => true do |t|
    t.string   "image_file",                :null => false
    t.integer  "contest_id",                :null => false
    t.integer  "user_id",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "up_votes",   :default => 0, :null => false
    t.string   "user_name",                 :null => false
    t.string   "user_email",                :null => false
    t.integer  "flags",      :default => 0, :null => false
  end

  add_index "images", ["contest_id", "user_id"], :name => "index_images_on_contest_id_and_user_id"
  add_index "images", ["contest_id"], :name => "index_images_on_contest_id"
  add_index "images", ["user_id"], :name => "index_images_on_user_id"

  create_table "rails_admin_histories", :force => true do |t|
    t.string   "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_histories_on_item_and_table_and_month_and_year"

  create_table "users", :force => true do |t|
    t.string   "uid",                                                   :null => false
    t.text     "credentials"
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "up_votes",                              :default => 0,  :null => false
    t.string   "lang"
    t.integer  "flags",                                 :default => 0,  :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["uid"], :name => "index_users_on_uid", :unique => true

  create_table "votings", :force => true do |t|
    t.string   "voteable_type"
    t.integer  "voteable_id"
    t.string   "voter_type"
    t.integer  "voter_id"
    t.boolean  "up_vote",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votings", ["voteable_type", "voteable_id", "voter_type", "voter_id"], :name => "unique_voters", :unique => true
  add_index "votings", ["voteable_type", "voteable_id"], :name => "index_votings_on_voteable_type_and_voteable_id"
  add_index "votings", ["voter_type", "voter_id"], :name => "index_votings_on_voter_type_and_voter_id"

end
