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

ActiveRecord::Schema.define(version: 20160701133223) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "fuzzystrmatch"

  create_table "comments", force: :cascade do |t|
    t.text     "content",          null: false
    t.string   "commentable_type", null: false
    t.integer  "commentable_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",          null: false
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "dependencies", force: :cascade do |t|
    t.integer  "master_project_id", null: false
    t.integer  "sub_project_id",    null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "domains", force: :cascade do |t|
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "installations", force: :cascade do |t|
    t.integer  "server_id",                           null: false
    t.string   "role",                                null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_instance_id",                 null: false
    t.datetime "deleted_at"
    t.boolean  "closing",             default: false
    t.index ["deleted_at"], name: "index_installations_on_deleted_at", using: :btree
    t.index ["project_instance_id"], name: "index_installations_on_project_instance_id", using: :btree
    t.index ["server_id"], name: "index_installations_on_server_id", using: :btree
  end

  create_table "models", force: :cascade do |t|
    t.integer  "domain_id"
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_id"], name: "index_models_on_domain_id", using: :btree
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.string   "searchable_type"
    t.integer  "searchable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_instances", force: :cascade do |t|
    t.integer  "project_id",                                null: false
    t.string   "name",                                      null: false
    t.string   "url",                                       null: false
    t.text     "backup_information"
    t.string   "stage",              default: "Production", null: false
    t.string   "branch"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.boolean  "closing",            default: false
    t.index ["deleted_at"], name: "index_project_instances_on_deleted_at", using: :btree
    t.index ["project_id"], name: "index_project_instances_on_project_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title",                                 null: false
    t.text     "description",                           null: false
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",             default: false
    t.string   "screenshot"
    t.string   "github_identifier"
    t.text     "dependencies"
    t.string   "state",                                 null: false
    t.string   "current_lead"
    t.text     "hacks"
    t.text     "external_clients",      default: [],                 array: true
    t.text     "project_leads",         default: [],                 array: true
    t.text     "developers",            default: [],                 array: true
    t.text     "pdrive_folders",        default: [],                 array: true
    t.text     "dropbox_folders",       default: [],                 array: true
    t.text     "pivotal_tracker_ids",   default: [],                 array: true
    t.text     "trello_ids",            default: [],                 array: true
    t.date     "expected_release_date"
    t.string   "rails_version"
    t.string   "ruby_version"
    t.string   "postgresql_version"
    t.text     "other_technologies",    default: [],                 array: true
    t.text     "internal_clients",      default: [],                 array: true
    t.text     "internal_description"
    t.text     "background_jobs"
    t.text     "cron_jobs"
    t.text     "user_access"
  end

  create_table "review_answers", force: :cascade do |t|
    t.integer  "review_id",                          null: false
    t.integer  "review_question_id",                 null: false
    t.boolean  "done",               default: false, null: false
    t.boolean  "skipped",            default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "review_questions", force: :cascade do |t|
    t.integer  "review_section_id",                 null: false
    t.text     "code",                              null: false
    t.text     "title",                             null: false
    t.text     "description"
    t.integer  "sort_order",        default: 0,     null: false
    t.boolean  "skippable",         default: false
    t.text     "auto_check"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "review_sections", force: :cascade do |t|
    t.text     "code",                   null: false
    t.text     "title",                  null: false
    t.integer  "sort_order", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "project_id",  null: false
    t.integer  "reviewer_id", null: false
    t.decimal  "result",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "servers", force: :cascade do |t|
    t.string   "name",                         null: false
    t.string   "domain",                       null: false
    t.string   "username"
    t.string   "admin_url"
    t.string   "os",                           null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "ssh_key_name"
    t.datetime "deleted_at"
    t.text     "open_ports",   default: [],                 array: true
    t.boolean  "closing",      default: false
    t.index ["deleted_at"], name: "index_servers_on_deleted_at", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "github"
    t.string   "token"
    t.boolean  "suspended",              default: false
    t.string   "name"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "comments", "users"
  add_foreign_key "dependencies", "projects", column: "master_project_id"
  add_foreign_key "dependencies", "projects", column: "sub_project_id"
  add_foreign_key "installations", "servers"
  add_foreign_key "models", "domains"
  add_foreign_key "review_answers", "review_questions"
  add_foreign_key "review_answers", "reviews"
  add_foreign_key "review_questions", "review_sections"
  add_foreign_key "reviews", "projects"
  add_foreign_key "reviews", "users", column: "reviewer_id"
end
