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

ActiveRecord::Schema.define(version: 20140501180411) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "connections", force: true do |t|
    t.integer  "linkedin_user_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.string   "first_name"
  end

  add_index "connections", ["linkedin_user_id"], name: "index_connections_on_linkedin_user_id", using: :btree
  add_index "connections", ["user_id"], name: "index_connections_on_user_id", using: :btree

  create_table "degrees", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "educations", force: true do |t|
    t.integer  "school_id"
    t.integer  "subject_id"
    t.integer  "degree_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "year"
  end

  add_index "educations", ["degree_id"], name: "index_educations_on_degree_id", using: :btree
  add_index "educations", ["school_id"], name: "index_educations_on_school_id", using: :btree
  add_index "educations", ["subject_id"], name: "index_educations_on_subject_id", using: :btree
  add_index "educations", ["user_id"], name: "index_educations_on_user_id", using: :btree

  create_table "industries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "industry_interests", force: true do |t|
    t.integer  "user_id"
    t.integer  "industry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "industry_interests", ["industry_id"], name: "index_industry_interests_on_industry_id", using: :btree
  add_index "industry_interests", ["user_id"], name: "index_industry_interests_on_user_id", using: :btree

  create_table "jobs", force: true do |t|
    t.integer  "company_id"
    t.integer  "position_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "jobs", ["company_id"], name: "index_jobs_on_company_id", using: :btree
  add_index "jobs", ["position_id"], name: "index_jobs_on_position_id", using: :btree
  add_index "jobs", ["user_id"], name: "index_jobs_on_user_id", using: :btree

  create_table "linkedin_users", force: true do |t|
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "location_interests", force: true do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "location_interests", ["location_id"], name: "index_location_interests_on_location_id", using: :btree
  add_index "location_interests", ["user_id"], name: "index_location_interests_on_user_id", using: :btree

  create_table "locations", force: true do |t|
    t.string   "area"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", force: true do |t|
    t.integer  "first_user_id"
    t.integer  "second_user_id"
    t.boolean  "match_status",       default: false
    t.boolean  "email_status",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_user_status",  default: "pending"
    t.string   "second_user_status", default: "pending"
  end

  add_index "matches", ["first_user_id"], name: "index_matches_on_first_user_id", using: :btree
  add_index "matches", ["second_user_id"], name: "index_matches_on_second_user_id", using: :btree

  create_table "positions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "references", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "other_user_id"
  end

  add_index "references", ["other_user_id"], name: "index_references_on_other_user_id", using: :btree
  add_index "references", ["user_id"], name: "index_references_on_user_id", using: :btree

  create_table "schools", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topic_interests", force: true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "topic_interests", ["topic_id"], name: "index_topic_interests_on_topic_id", using: :btree
  add_index "topic_interests", ["user_id"], name: "index_topic_interests_on_user_id", using: :btree

  create_table "topics", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "email"
    t.text     "headline"
    t.text     "summary"
    t.string   "image"
    t.string   "public_profile"
    t.integer  "location_id"
    t.boolean  "admin",             default: false
    t.float    "score",             default: 0.0
    t.string   "approved",          default: "pending"
    t.integer  "industry_id"
    t.string   "token"
    t.string   "secret"
    t.integer  "linkedin_user_id"
    t.text     "seeking"
    t.boolean  "signup_email",      default: false
    t.integer  "number_of_matches", default: 1
    t.boolean  "premium_email",     default: false
    t.boolean  "badge",             default: false
    t.boolean  "deleted",           default: false
    t.boolean  "active",            default: true
  end

  add_index "users", ["industry_id"], name: "index_users_on_industry_id", using: :btree
  add_index "users", ["linkedin_user_id"], name: "index_users_on_linkedin_user_id", using: :btree
  add_index "users", ["location_id"], name: "index_users_on_location_id", using: :btree

end
