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

ActiveRecord::Schema.define(version: 20150719231349) do

  create_table "article_groups", force: true do |t|
    t.integer   "created_of",              default: 0,  null: false
    t.timestamp "created_on",                           null: false
    t.integer   "updated_of",              default: 0,  null: false
    t.timestamp "updated_on",                           null: false
    t.string    "description",  limit: 16, default: "", null: false
    t.datetime  "expires_date"
    t.datetime  "suspend"
    t.integer   "group_id",                default: 0,  null: false
    t.integer   "article_id",              default: 0,  null: false
  end

  create_table "article_shows", force: true do |t|
    t.integer "article_id",           null: false
    t.binary  "headline",   limit: 1
    t.binary  "source",     limit: 1
    t.binary  "ingress",    limit: 1
    t.binary  "story_text", limit: 1
    t.binary  "dato",       limit: 1
  end

  create_table "article_versions", force: true do |t|
    t.integer   "article_id"
    t.integer   "version"
    t.integer   "created_of",               default: 0
    t.timestamp "created_on",                            null: false
    t.integer   "updated_of",               default: 0
    t.datetime  "updated_on"
    t.string    "source",       limit: 16,  default: ""
    t.text      "headline"
    t.string    "url",          limit: 128
    t.text      "ingress"
    t.text      "story_text"
    t.integer   "picture"
    t.datetime  "expires_date"
    t.datetime  "suspend"
    t.integer   "un_published"
    t.integer   "pri"
    t.integer   "owner",                    default: 0
    t.string    "cloth",        limit: 1
  end

  create_table "articles", force: true do |t|
    t.integer   "created_of",                      default: 0, null: false
    t.timestamp "created_on",                                  null: false
    t.integer   "updated_of",                      default: 0, null: false
    t.timestamp "updated_on",                                  null: false
    t.string    "source",       limit: 128
    t.text      "headline",                                    null: false
    t.string    "url",          limit: 128
    t.text      "ingress",                                     null: false
    t.text      "story_text",   limit: 2147483647
    t.integer   "picture"
    t.datetime  "expires_date"
    t.datetime  "suspend"
    t.integer   "un_published", limit: 1
    t.integer   "pri"
    t.integer   "owner",                           default: 0, null: false
    t.integer   "version"
    t.string    "cloth",        limit: 1
  end

  add_index "articles", ["headline", "ingress", "story_text"], name: "his_index", type: :fulltext

  create_table "brukere", force: true do |t|
    t.string  "brukernavn", limit: 20, default: "", null: false
    t.text    "passord"
    t.string  "full_navn",  limit: 16, default: "", null: false
    t.string  "writer",     limit: 16, default: "", null: false
    t.string  "page",       limit: 16, default: "", null: false
    t.integer "gruppe"
    t.integer "published"
    t.string  "epost",      limit: 35, default: "", null: false
  end

  add_index "brukere", ["brukernavn"], name: "brukernavn", using: :btree

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

  create_table "engine_schema_info", id: false, force: true do |t|
    t.string  "engine_name"
    t.integer "version"
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
    t.string    "name",        limit: 64
    t.text      "description",                        null: false
    t.integer   "created_of",             default: 0, null: false
    t.timestamp "created_at",                         null: false
    t.integer   "updated_of",             default: 0, null: false
    t.timestamp "updated_on",                         null: false
    t.integer   "owner",                  default: 0, null: false
    t.string    "extension"
    t.string    "bane",        limit: 32
  end

  add_index "images", ["created_of"], name: "fk_items_created_of", using: :btree
  add_index "images", ["owner"], name: "fk_items_owner", using: :btree
  add_index "images", ["updated_of"], name: "fk_items_updated_of", using: :btree

  create_table "intra", force: true do |t|
    t.string  "writer",     limit: 16,         default: "", null: false
    t.string  "page",       limit: 16,         default: "", null: false
    t.text    "medie",                                      null: false
    t.text    "headline",                                   null: false
    t.text    "url"
    t.text    "story_text"
    t.text    "hoveddel",   limit: 2147483647
    t.text    "picture"
    t.integer "created"
    t.integer "modified"
    t.integer "published"
    t.integer "temaid"
    t.integer "temaid2"
    t.integer "temaid3"
    t.integer "pri",        limit: 1
  end

  create_table "iptocs", force: true do |t|
    t.integer "ip_from",                  null: false
    t.integer "ip_to",                    null: false
    t.string  "country_code2", limit: 2,  null: false
    t.string  "country_code3", limit: 3,  null: false
    t.string  "country_name",  limit: 50, null: false
  end

  add_index "iptocs", ["id"], name: "id", unique: true, using: :btree
  add_index "iptocs", ["ip_from", "ip_to"], name: "ip_from", unique: true, using: :btree

  create_table "keywords", id: false, force: true do |t|
    t.integer "story",              default: 0,  null: false
    t.string  "keyword", limit: 32, default: "", null: false
    t.integer "weight",             default: 0,  null: false
  end

  create_table "menu_elements", force: true do |t|
    t.integer  "type"
    t.integer  "parent"
    t.string   "text"
    t.string   "href"
    t.text     "html"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "placement"
  end

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

  create_table "org", force: true do |t|
    t.string  "writer",     limit: 16,         default: "", null: false
    t.string  "page",       limit: 16,         default: "", null: false
    t.text    "medie",                                      null: false
    t.text    "headline",                                   null: false
    t.text    "url"
    t.text    "lenke"
    t.text    "story_text"
    t.text    "hoveddel",   limit: 2147483647
    t.text    "picture"
    t.integer "created"
    t.integer "modified"
    t.integer "published"
    t.integer "temaid"
    t.integer "temaid2"
    t.integer "temaid3"
    t.integer "pri",        limit: 1
  end

  create_table "orgtem", force: true do |t|
    t.string  "kode",        limit: 20, default: "", null: false
    t.text    "description"
    t.string  "writer",      limit: 16, default: "", null: false
    t.string  "page",        limit: 16, default: "", null: false
    t.integer "published"
  end

  create_table "pages", primary_key: "code", force: true do |t|
    t.text "description"
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

  create_table "presse", force: true do |t|
    t.string  "lagtinnav",    limit: 16, default: "", null: false
    t.string  "endretav",     limit: 16
    t.integer "datoinn",                 default: 0,  null: false
    t.integer "datoendret",              default: 0,  null: false
    t.string  "medie",        limit: 16
    t.string  "organisasjon", limit: 16
    t.string  "fylke",        limit: 20
    t.text    "medienavn",                            null: false
    t.text    "epost",                                null: false
    t.integer "postnr"
    t.text    "kontakt"
    t.integer "tlf"
    t.integer "flagg",        limit: 1
    t.string  "published",    limit: 16
  end

  create_table "pressebruker", force: true do |t|
    t.string "bruker",   limit: 16, default: "", null: false
    t.text   "fraepost",                         null: false
    t.text   "org",                              null: false
  end

  create_table "pressefra", force: true do |t|
    t.text   "epost",                          null: false
    t.text   "navn",                           null: false
    t.text   "sig",                            null: false
    t.text   "subject",                        null: false
    t.string "org",     limit: 4, default: "", null: false
    t.string "bokstav", limit: 1, default: "", null: false
  end

  create_table "rail_stats", force: true do |t|
    t.string   "remote_ip"
    t.string   "country"
    t.string   "language"
    t.string   "domain"
    t.string   "subdomain"
    t.string   "referer"
    t.string   "resource"
    t.string   "user_agent"
    t.string   "platform"
    t.string   "browser"
    t.string   "version"
    t.datetime "created_at"
    t.date     "created_on"
    t.string   "screen_size"
    t.string   "colors"
    t.string   "java"
    t.string   "java_enabled"
    t.string   "flash"
  end

  add_index "rail_stats", ["subdomain"], name: "rail_stats_subdomain_index", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name",                         default: "",    null: false
    t.string   "description"
    t.boolean  "omnipotent",                   default: false, null: false
    t.boolean  "system_role"
    t.string   "authorizable_type", limit: 30
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schema_info", id: false, force: true do |t|
    t.integer "version"
  end

  create_table "search_terms", force: true do |t|
    t.string  "subdomain",   default: ""
    t.string  "searchterms", default: "", null: false
    t.integer "count",       default: 0,  null: false
    t.string  "domain"
  end

  add_index "search_terms", ["subdomain"], name: "search_terms_subdomain_index", using: :btree

  create_table "sitealizer", force: true do |t|
    t.string   "path"
    t.string   "ip"
    t.string   "referer"
    t.string   "language"
    t.string   "user_agent"
    t.datetime "created_at"
    t.date     "created_on"
  end

  create_table "stat_options", id: false, force: true do |t|
    t.string "bad_ip",                  default: "255.255.255.255:",          null: false
    t.string "site_url",                default: "http://www.tjen-folket.no", null: false
    t.string "cookie_value", limit: 3,  default: "on",                        null: false
    t.string "cookie_id",    limit: 20, default: "php_qs_wm_ck",              null: false
  end

  create_table "stat_page_views", id: false, force: true do |t|
    t.integer "ID",                             null: false
    t.string  "page",  limit: 100, default: "", null: false
    t.integer "count",             default: 0,  null: false
  end

  add_index "stat_page_views", ["ID"], name: "ID", using: :btree

  create_table "stat_stats", id: false, force: true do |t|
    t.string "php_id",     limit: 50, default: "",                    null: false
    t.string "refer",                 default: "",                    null: false
    t.string "browser",               default: "",                    null: false
    t.string "os",         limit: 50, default: "",                    null: false
    t.date   "date",                                                  null: false
    t.time   "time",                  default: '2000-01-01 00:00:00', null: false
    t.string "ip_addr",    limit: 20, default: "",                    null: false
    t.string "agent",                 default: "",                    null: false
    t.string "entry_page",            default: "",                    null: false
    t.string "ref_full",              default: "",                    null: false
  end

  add_index "stat_stats", ["php_id"], name: "php_id", using: :btree

  create_table "stories", force: true do |t|
    t.string  "writer",     limit: 16, default: "", null: false
    t.string  "page",       limit: 16, default: "", null: false
    t.text    "medie",                              null: false
    t.text    "headline",                           null: false
    t.text    "url"
    t.text    "story_text"
    t.text    "picture"
    t.integer "created"
    t.integer "modified"
    t.integer "published"
    t.integer "temaid"
    t.integer "temaid2"
    t.integer "temaid3"
    t.integer "pri",        limit: 1
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

  create_table "temaer", force: true do |t|
    t.string  "kode",        limit: 20, default: "", null: false
    t.text    "description"
    t.string  "writer",      limit: 16, default: "", null: false
    t.string  "page",        limit: 16, default: "", null: false
    t.integer "published"
    t.integer "pri",         limit: 1
  end

  create_table "users", force: true do |t|
    t.string   "login",           limit: 80, default: "", null: false
    t.string   "salted_password", limit: 40, default: "", null: false
    t.string   "email",           limit: 60, default: "", null: false
    t.string   "firstname",       limit: 40
    t.string   "lastname",        limit: 40
    t.string   "salt",            limit: 40, default: "", null: false
    t.integer  "verified",                   default: 0
    t.string   "role",            limit: 40
    t.string   "security_token",  limit: 40
    t.datetime "token_expiry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "logged_in_at"
    t.integer  "deleted",                    default: 0
    t.datetime "delete_after"
  end

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id", default: 0, null: false
    t.integer "role_id", default: 0, null: false
  end

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "writer_permissions", id: false, force: true do |t|
    t.string "writer", limit: 16, default: "", null: false
    t.string "page",   limit: 16, default: "", null: false
  end

end
