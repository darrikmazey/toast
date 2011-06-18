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

ActiveRecord::Schema.define(:version => 20110618074934) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "pages", :force => true do |t|
    t.string   "url"
    t.integer  "scraper_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "found_at"
    t.datetime "scrape_started_at"
    t.datetime "scrape_ended_at"
  end

  add_index "pages", ["scrape_started_at", "scrape_ended_at"], :name => "scrape_times_index"
  add_index "pages", ["scraper_id"], :name => "scraper_id_index"

  create_table "parameters", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "scraper_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "postings", :force => true do |t|
    t.integer  "scraper_id"
    t.boolean  "loaded"
    t.string   "url"
    t.string   "brief_content"
    t.string   "poster"
    t.string   "email"
    t.datetime "posted_at"
    t.text     "long_content"
    t.string   "posting_id"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "new",           :default => true
    t.boolean  "ignored",       :default => false
  end

  add_index "postings", ["ignored"], :name => "ignored_index"
  add_index "postings", ["loaded"], :name => "loaded_index"
  add_index "postings", ["new"], :name => "new_index"
  add_index "postings", ["page_id"], :name => "page_id_index"
  add_index "postings", ["posted_at"], :name => "posted_at_index"
  add_index "postings", ["scraper_id"], :name => "scraper_id_index"
  add_index "postings", ["url"], :name => "url_index"

  create_table "scrapers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
