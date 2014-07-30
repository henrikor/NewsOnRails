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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140727135754) do

  create_table "article_groups", force: true do |t|
    t.integer  "created_of",   limit: 8,  default: 0,  null: false
    t.datetime "created_on",                           null: false
    t.integer  "updated_of",   limit: 8,  default: 0,  null: false
    t.datetime "updated_on",                           null: false
    t.string   "description",  limit: 16, default: "", null: false
    t.datetime "expires_date"
    t.datetime "suspend"
    t.integer  "group_id",     limit: 8,  default: 0,  null: false
    t.integer  "article_id",   limit: 8,  default: 0,  null: false
  end

  create_table "article_shows", force: true do |t|
    t.integer "article_id", limit: 8, default: 0, null: false
    t.boolean "headline"
    t.boolean "source"
    t.boolean "ingress"
    t.boolean "story_text"
    t.boolean "dato"
  end

  create_table "article_versions", force: true do |t|
    t.integer  "article_id",   limit: 8
    t.integer  "version",      limit: 8
    t.integer  "created_of",   limit: 8,   default: 0
    t.datetime "created_on",                            null: false
    t.integer  "updated_of",   limit: 8,   default: 0
    t.datetime "updated_on"
    t.string   "source",       limit: 16,  default: ""
    t.text     "headline",     limit: 255
    t.string   "url",          limit: 128
    t.text     "ingress"
    t.text     "story_text"
    t.integer  "picture",      limit: 8
    t.datetime "expires_date"
    t.datetime "suspend"
    t.integer  "un_published"
    t.integer  "pri",          limit: 8
    t.integer  "owner",        limit: 8,   default: 0
    t.string   "cloth",        limit: 1
  end

  create_table "articles", force: true do |t|
    t.integer  "created_of",   limit: 8,          default: 0, null: false
    t.datetime "created_on",                                  null: false
    t.integer  "updated_of",   limit: 8,          default: 0, null: false
    t.datetime "updated_on",                                  null: false
    t.string   "source",       limit: 128
    t.text     "headline",     limit: 255,                    null: false
    t.string   "url",          limit: 128
    t.text     "ingress",                                     null: false
    t.text     "story_text",   limit: 2147483647
    t.integer  "picture",      limit: 8
    t.datetime "expires_date"
    t.datetime "suspend"
    t.integer  "un_published"
    t.integer  "pri",          limit: 8
    t.integer  "owner",        limit: 8,          default: 0, null: false
    t.integer  "version",      limit: 8
    t.string   "cloth",        limit: 1
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.string   "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_groups", force: true do |t|
    t.integer   "created_of",              default: 0,  null: false
    t.timestamp "created_on",                           null: false
    t.integer   "updated_of",              default: 0,  null: false
    t.timestamp "updated_on",                           null: false
    t.string    "description",  limit: 16, default: "", null: false
    t.datetime  "expires_date"
    t.datetime  "suspend"
    t.integer   "group_id",                default: 0,  null: false
    t.integer   "group_id2",               default: 0,  null: false
  end

  create_table "group_members", force: true do |t|
    t.integer   "created_of",              default: 0,  null: false
    t.timestamp "created_on",                           null: false
    t.integer   "updated_of",              default: 0,  null: false
    t.timestamp "updated_on",                           null: false
    t.string    "description",  limit: 16, default: "", null: false
    t.datetime  "expires_date"
    t.datetime  "suspend"
    t.integer   "group_id",                default: 0,  null: false
    t.integer   "user_id",                 default: 0,  null: false
  end

  create_table "group_roles", force: true do |t|
    t.integer "group_id", default: 0, null: false
    t.integer "role_id",  default: 0, null: false
  end

  create_table "groups", force: true do |t|
    t.integer   "created_of",              default: 0, null: false
    t.timestamp "created_on",                          null: false
    t.integer   "updated_of",              default: 0, null: false
    t.timestamp "updated_on",                          null: false
    t.string    "name",         limit: 80
    t.text      "description"
    t.datetime  "expires_date"
    t.datetime  "suspend"
  end

  create_table "groups_stylesheets", id: false, force: true do |t|
    t.integer "group_id",      default: 0, null: false
    t.integer "stylesheet_id", default: 0, null: false
  end

  add_index "groups_stylesheets", ["group_id"], name: "fk_items_groups", using: :btree
  add_index "groups_stylesheets", ["stylesheet_id"], name: "fk_items_stylesheets", using: :btree

  create_table "images", force: true do |t|
    t.integer   "file"
    t.string    "name",        limit: 32, default: "", null: false
    t.text      "description",                         null: false
    t.integer   "created_of",             default: 0,  null: false
    t.timestamp "created_at",                          null: false
    t.integer   "updated_of",             default: 0,  null: false
    t.timestamp "updated_on",                          null: false
    t.integer   "owner",                  default: 0,  null: false
    t.string    "extension"
    t.string    "bane",        limit: 32
  end

  add_index "images", ["created_of"], name: "fk_items_created_of", using: :btree
  add_index "images", ["owner"], name: "fk_items_owner", using: :btree
  add_index "images", ["updated_of"], name: "fk_items_updated_of", using: :btree

  create_table "norusers", force: true do |t|
    t.string    "login"
    t.string    "email"
    t.string    "crypted_password",          limit: 40
    t.string    "salt",                      limit: 40
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.string    "remember_token"
    t.datetime  "remember_token_expires_at"
    t.string    "firstname",                 limit: 40
    t.string    "lastname",                  limit: 40
    t.string    "password_reset_code",       limit: 40
    t.string    "activation_code",           limit: 40
    t.timestamp "activated_at",                         null: false
  end

  create_table "norusers_roles", id: false, force: true do |t|
    t.integer  "noruser_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", force: true do |t|
    t.string "controller",  default: "", null: false
    t.string "action",      default: "", null: false
    t.string "description"
  end

  create_table "permissions_roles", id: false, force: true do |t|
    t.integer "permission_id", default: 0, null: false
    t.integer "role_id",       default: 0, null: false
  end

  create_table "roles", force: true do |t|
    t.string   "name",              limit: 40
    t.string   "authorizable_type", limit: 30
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "schema_info", id: false, force: true do |t|
    t.integer "version"
  end

  create_table "stylesheets", force: true do |t|
    t.integer   "created_of",                    default: 0,  null: false
    t.timestamp "created_on",                                 null: false
    t.integer   "updated_of",                    default: 0,  null: false
    t.timestamp "updated_on",                                 null: false
    t.string    "name",       limit: 16,         default: "", null: false
    t.text      "css",        limit: 2147483647,              null: false
    t.integer   "owner",                         default: 0,  null: false
  end

  add_index "stylesheets", ["created_of"], name: "fk_items_users", using: :btree
  add_index "stylesheets", ["owner"], name: "fk_items_roles", using: :btree
  add_index "stylesheets", ["updated_of"], name: "fk_items_users2", using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
