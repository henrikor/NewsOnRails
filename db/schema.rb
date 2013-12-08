# -*- encoding : utf-8 -*-
# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "article_groups", :force => true do |t|
    t.integer   "created_of",   :limit => 11, :default => 0,  :null => false
    t.timestamp "created_on",                                 :null => false
    t.integer   "updated_of",   :limit => 11, :default => 0,  :null => false
    t.timestamp "updated_on",                                 :null => false
    t.string    "description",  :limit => 16, :default => "", :null => false
    t.datetime  "expires_date"
    t.datetime  "suspend"
    t.integer   "group_id",     :limit => 11, :default => 0,  :null => false
    t.integer   "article_id",   :limit => 11, :default => 0,  :null => false
  end

  create_table "article_shows", :force => true do |t|
    t.integer "article_id", :limit => 11, :default => 0, :null => false
    t.boolean "headline"
    t.boolean "source"
    t.boolean "ingress"
    t.boolean "story_text"
    t.boolean "dato"
  end

  create_table "article_versions", :force => true do |t|
    t.integer   "article_id",   :limit => 11
    t.integer   "version",      :limit => 11
    t.integer   "created_of",   :limit => 11,  :default => 0
    t.timestamp "created_on",                                  :null => false
    t.integer   "updated_of",   :limit => 11,  :default => 0
    t.datetime  "updated_on"
    t.string    "source",       :limit => 16,  :default => ""
    t.text      "headline"
    t.string    "url",          :limit => 128
    t.text      "ingress"
    t.text      "story_text"
    t.integer   "picture",      :limit => 11
    t.datetime  "expires_date"
    t.datetime  "suspend"
    t.integer   "un_published", :limit => 4
    t.integer   "pri",          :limit => 11
    t.integer   "owner",        :limit => 11,  :default => 0
    t.string    "cloth",        :limit => 1
  end

  create_table "articles", :force => true do |t|
    t.integer   "created_of",   :limit => 11,         :default => 0, :null => false
    t.timestamp "created_on",                                        :null => false
    t.integer   "updated_of",   :limit => 11,         :default => 0, :null => false
    t.timestamp "updated_on",                                        :null => false
    t.string    "source",       :limit => 128
    t.text      "headline",                                          :null => false
    t.string    "url",          :limit => 128
    t.text      "ingress",                                           :null => false
    t.text      "story_text",   :limit => 2147483647
    t.integer   "picture",      :limit => 11
    t.datetime  "expires_date"
    t.datetime  "suspend"
    t.integer   "un_published", :limit => 4
    t.integer   "pri",          :limit => 11
    t.integer   "owner",        :limit => 11,         :default => 0, :null => false
    t.integer   "version",      :limit => 11
    t.string    "cloth",        :limit => 1
  end

  add_index "articles", ["headline", "ingress", "story_text"], :name => "his_index"

  create_table "engine_schema_info", :id => false, :force => true do |t|
    t.string  "engine_name"
    t.integer "version",     :limit => 11
  end

  create_table "group_groups", :force => true do |t|
    t.integer   "created_of",   :limit => 11, :default => 0,  :null => false
    t.timestamp "created_on",                                 :null => false
    t.integer   "updated_of",   :limit => 11, :default => 0,  :null => false
    t.timestamp "updated_on",                                 :null => false
    t.string    "description",  :limit => 16, :default => "", :null => false
    t.datetime  "expires_date"
    t.datetime  "suspend"
    t.integer   "group_id",     :limit => 11, :default => 0,  :null => false
    t.integer   "group_id2",    :limit => 11, :default => 0,  :null => false
  end

  create_table "group_members", :force => true do |t|
    t.integer   "created_of",   :limit => 11, :default => 0,  :null => false
    t.timestamp "created_on",                                 :null => false
    t.integer   "updated_of",   :limit => 11, :default => 0,  :null => false
    t.timestamp "updated_on",                                 :null => false
    t.string    "description",  :limit => 16, :default => "", :null => false
    t.datetime  "expires_date"
    t.datetime  "suspend"
    t.integer   "group_id",     :limit => 11, :default => 0,  :null => false
    t.integer   "user_id",      :limit => 11, :default => 0,  :null => false
  end

  create_table "group_roles", :force => true do |t|
    t.integer "group_id", :limit => 11, :default => 0, :null => false
    t.integer "role_id",  :limit => 11, :default => 0, :null => false
  end

  create_table "groups", :force => true do |t|
    t.integer   "created_of",   :limit => 11, :default => 0, :null => false
    t.timestamp "created_on",                                :null => false
    t.integer   "updated_of",   :limit => 11, :default => 0, :null => false
    t.timestamp "updated_on",                                :null => false
    t.string    "name",         :limit => 80
    t.text      "description"
    t.datetime  "expires_date"
    t.datetime  "suspend"
  end

  create_table "groups_stylesheets", :id => false, :force => true do |t|
    t.integer "group_id",      :limit => 11, :default => 0, :null => false
    t.integer "stylesheet_id", :limit => 11, :default => 0, :null => false
  end

  add_index "groups_stylesheets", ["group_id"], :name => "fk_items_groups"
  add_index "groups_stylesheets", ["stylesheet_id"], :name => "fk_items_stylesheets"

  create_table "images", :force => true do |t|
    t.integer   "file",        :limit => 11
    t.string    "name",        :limit => 32, :default => "", :null => false
    t.text      "description",                               :null => false
    t.integer   "created_of",  :limit => 11, :default => 0,  :null => false
    t.timestamp "created_at",                                :null => false
    t.integer   "updated_of",  :limit => 11, :default => 0,  :null => false
    t.timestamp "updated_on",                                :null => false
    t.integer   "owner",       :limit => 11, :default => 0,  :null => false
    t.string    "extension"
    t.string    "bane",        :limit => 32
  end

  add_index "images", ["created_of"], :name => "fk_items_created_of"
  add_index "images", ["updated_of"], :name => "fk_items_updated_of"
  add_index "images", ["owner"], :name => "fk_items_owner"

  create_table "norusers", :force => true do |t|
    t.string    "login"
    t.string    "email"
    t.string    "crypted_password",          :limit => 40
    t.string    "salt",                      :limit => 40
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.string    "remember_token"
    t.datetime  "remember_token_expires_at"
    t.string    "firstname",                 :limit => 40
    t.string    "lastname",                  :limit => 40
    t.string    "password_reset_code",       :limit => 40
    t.string    "activation_code",           :limit => 40
    t.timestamp "activated_at",                            :null => false
  end

  create_table "norusers_roles", :id => false, :force => true do |t|
    t.integer  "noruser_id", :limit => 11
    t.integer  "role_id",    :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "org", :force => true do |t|
    t.string  "writer",     :limit => 16,         :default => "", :null => false
    t.string  "page",       :limit => 16,         :default => "", :null => false
    t.text    "medie",                                            :null => false
    t.text    "headline",                                         :null => false
    t.text    "url"
    t.text    "story_text"
    t.text    "hoveddel",   :limit => 2147483647
    t.text    "picture"
    t.integer "created",    :limit => 11
    t.integer "modified",   :limit => 11
    t.integer "published",  :limit => 11
    t.integer "temaid",     :limit => 11
    t.integer "temaid2",    :limit => 11
    t.integer "temaid3",    :limit => 11
    t.integer "pri",        :limit => 4
  end

  add_index "org", ["headline", "story_text", "hoveddel"], :name => "headline"

  create_table "permissions", :force => true do |t|
    t.string "controller",  :default => "", :null => false
    t.string "action",      :default => "", :null => false
    t.string "description"
  end

  create_table "permissions_roles", :id => false, :force => true do |t|
    t.integer "permission_id", :limit => 11, :default => 0, :null => false
    t.integer "role_id",       :limit => 11, :default => 0, :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 30
    t.integer  "authorizable_id",   :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version", :limit => 11
  end

  create_table "stories", :force => true do |t|
    t.string  "writer",     :limit => 16, :default => "", :null => false
    t.string  "page",       :limit => 16, :default => "", :null => false
    t.text    "medie",                                    :null => false
    t.text    "headline",                                 :null => false
    t.text    "url"
    t.text    "story_text"
    t.text    "picture"
    t.integer "created",    :limit => 11
    t.integer "modified",   :limit => 11
    t.integer "published",  :limit => 11
    t.integer "temaid",     :limit => 11
    t.integer "temaid2",    :limit => 11
    t.integer "temaid3",    :limit => 11
    t.integer "pri",        :limit => 4
  end

  add_index "stories", ["headline", "story_text"], :name => "headline"

  create_table "stylesheets", :force => true do |t|
    t.integer   "created_of", :limit => 11,         :default => 0,  :null => false
    t.timestamp "created_on",                                       :null => false
    t.integer   "updated_of", :limit => 11,         :default => 0,  :null => false
    t.timestamp "updated_on",                                       :null => false
    t.string    "name",       :limit => 16,         :default => "", :null => false
    t.text      "css",        :limit => 2147483647,                 :null => false
    t.integer   "owner",      :limit => 11,         :default => 0,  :null => false
  end

  add_index "stylesheets", ["created_of"], :name => "fk_items_users"
  add_index "stylesheets", ["updated_of"], :name => "fk_items_users2"
  add_index "stylesheets", ["owner"], :name => "fk_items_roles"

  create_table "super_images", :force => true do |t|
    t.binary   "data",       :limit => 16777215
    t.datetime "created_at"
  end

  create_table "temaer", :force => true do |t|
    t.string  "kode",        :limit => 20, :default => "", :null => false
    t.text    "description"
    t.string  "writer",      :limit => 16, :default => "", :null => false
    t.string  "page",        :limit => 16, :default => "", :null => false
    t.integer "published",   :limit => 11
    t.text    "innledning"
  end

  create_table "users", :force => true do |t|
    t.string   "login",           :limit => 80, :default => "", :null => false
    t.string   "salted_password", :limit => 40, :default => "", :null => false
    t.string   "email",           :limit => 60, :default => "", :null => false
    t.string   "firstname",       :limit => 40
    t.string   "lastname",        :limit => 40
    t.string   "salt",            :limit => 40, :default => "", :null => false
    t.integer  "verified",        :limit => 11, :default => 0
    t.string   "role",            :limit => 40
    t.string   "security_token",  :limit => 40
    t.datetime "token_expiry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "logged_in_at"
    t.integer  "deleted",         :limit => 11, :default => 0
    t.datetime "delete_after"
  end

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id", :limit => 11, :default => 0, :null => false
    t.integer "role_id", :limit => 11, :default => 0, :null => false
  end

end
