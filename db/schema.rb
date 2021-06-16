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

ActiveRecord::Schema.define(version: 20210616202349) do

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
    t.integer  "master_product_id", null: false
    t.integer  "sub_product_id",    null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "domains", force: :cascade do |t|
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "installations", force: :cascade do |t|
    t.integer  "server_id",                           null: false
    t.string   "role",                                null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_instance_id",                 null: false
    t.datetime "deleted_at"
    t.boolean  "closing",             default: false
    t.index ["deleted_at"], name: "index_installations_on_deleted_at", using: :btree
    t.index ["product_instance_id"], name: "index_installations_on_product_instance_id", using: :btree
    t.index ["server_id"], name: "index_installations_on_server_id", using: :btree
  end

  create_table "kpis", force: :cascade do |t|
    t.integer  "singleton_guard",                      default: 0, null: false
    t.text     "percentage_currently_active_products"
    t.float    "total_income"
    t.integer  "bugs_backlog_size",                    default: 0
    t.text     "percentage_products_with_kpis"
    t.text     "product_vulnerability_counts"
    t.text     "percentage_products_with_ci"
    t.text     "percentage_products_documented"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.text     "bugs_severity"
    t.text     "manual_yearly_updates_overview"
    t.text     "product_breakdown"
    t.text     "level_of_involvement"
    t.index ["singleton_guard"], name: "index_kpis_on_singleton_guard", unique: true, using: :btree
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

  create_table "product_instances", force: :cascade do |t|
    t.integer  "product_id",                                null: false
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
    t.index ["deleted_at"], name: "index_product_instances_on_deleted_at", using: :btree
    t.index ["product_id"], name: "index_product_instances_on_product_id", using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.string   "title",                                       null: false
    t.text     "description",                                 null: false
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",                   default: false
    t.string   "screenshot"
    t.string   "github_identifier"
    t.text     "dependencies"
    t.string   "state",                                       null: false
    t.string   "current_lead"
    t.text     "hacks"
    t.text     "external_clients",            default: [],                 array: true
    t.text     "product_leads",               default: [],                 array: true
    t.text     "developers",                  default: [],                 array: true
    t.text     "pdrive_folders",              default: [],                 array: true
    t.text     "dropbox_folders",             default: [],                 array: true
    t.text     "pivotal_tracker_ids",         default: [],                 array: true
    t.text     "trello_ids",                  default: [],                 array: true
    t.date     "expected_release_date"
    t.string   "rails_version"
    t.string   "ruby_version"
    t.string   "postgresql_version"
    t.text     "other_technologies",          default: [],                 array: true
    t.text     "internal_clients",            default: [],                 array: true
    t.text     "internal_description"
    t.text     "background_jobs"
    t.text     "cron_jobs"
    t.text     "user_access"
    t.string   "project_code"
    t.string   "url_staging"
    t.text     "codebase_url"
    t.text     "design_link"
    t.text     "sharepoint_link"
    t.text     "ga_tracking_code"
    t.string   "designers",                   default: [],                 array: true
    t.float    "income_earned"
    t.string   "key_performance_indicator"
    t.string   "kpi_measurement"
    t.boolean  "is_feasible"
    t.string   "documentation_link"
    t.boolean  "is_documentation_adequate"
    t.float    "manual_yearly_updates",       default: 0.0
    t.date     "last_commit_date"
    t.text     "product_leading_style"
    t.integer  "google_analytics_user_count"
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
    t.integer  "product_id",  null: false
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
  add_foreign_key "dependencies", "products", column: "master_product_id"
  add_foreign_key "dependencies", "products", column: "sub_product_id"
  add_foreign_key "installations", "servers"
  add_foreign_key "models", "domains"
  add_foreign_key "review_answers", "review_questions"
  add_foreign_key "review_answers", "reviews"
  add_foreign_key "review_questions", "review_sections"
  add_foreign_key "reviews", "products"
  add_foreign_key "reviews", "users", column: "reviewer_id"
end
