# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20141009073508) do

# Could not dump table "cms_articles" because of following StandardError
#   Unknown type 'json' for column 'nested_pages'

  create_table "cms_images", :force => true do |t|
    t.string   "slug"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "image_file"
    t.string   "title"
    t.text     "url"
  end

  create_table "core_oauths", :force => true do |t|
    t.string   "token"
    t.datetime "expires_at"
    t.string   "refresh_token"
    t.string   "profile"
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "core_tags", :force => true do |t|
    t.string   "genre"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "slug"
    t.integer  "sort_order"
  end

  create_table "data_filzs", :force => true do |t|
    t.string   "genre"
    t.string   "slug"
    t.string   "file_file_name"
    t.text     "content"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "core_oauth_id"
  end

  add_index "data_filzs", ["slug"], :name => "index_data_filzs_on_slug"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "iso_codes", :force => true do |t|
    t.string   "code"
    t.string   "country"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "continent"
  end

  create_table "providers", :force => true do |t|
    t.string   "provider_id"
    t.string   "name"
    t.string   "provider_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.datetime "requested_at"
    t.datetime "request_end"
    t.boolean  "is_processed"
    t.string   "wiki_name"
    t.string   "error_message"
    t.text     "text_at_top"
    t.text     "text_at_bottom"
  end

  create_table "settings", :force => true do |t|
    t.boolean  "masonry"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "image"
    t.string   "header_name"
    t.text     "page_builder_config"
  end

  create_table "users", :force => true do |t|
    t.string   "email",         :default => "", :null => false
    t.string   "password",      :default => "", :null => false
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "viz_charts", :force => true do |t|
    t.string   "name"
    t.string   "genre"
    t.text     "img"
    t.text     "mapping"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
  end

  create_table "viz_vizs", :force => true do |t|
    t.string   "title"
    t.integer  "data_filz_id"
    t.text     "map"
    t.text     "mapped_output"
    t.text     "settings"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "slug"
    t.string   "chart"
  end

end
