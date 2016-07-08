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

ActiveRecord::Schema.define(version: 20160707235250) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "cms_contents", force: :cascade do |t|
    t.string   "key"
    t.text     "cms_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "download_files", force: :cascade do |t|
    t.integer  "idea_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "downloadable_file_name"
    t.string   "downloadable_content_type"
    t.integer  "downloadable_file_size"
    t.datetime "downloadable_updated_at"
  end

  create_table "idea_assignments", force: :cascade do |t|
    t.integer  "idea_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "groupable_type"
    t.integer  "groupable_id"
    t.float    "budget"
    t.integer  "ordering"
  end

  add_index "idea_assignments", ["ordering"], name: "index_orderings_in_idea_assignments", using: :btree

  create_table "ideas", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "individual_answers", force: :cascade do |t|
    t.integer  "response_id"
    t.integer  "survey_question_id"
    t.string   "survey_public_link"
    t.jsonb    "response_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "respondent_id"
  end

  create_table "question_assignments", force: :cascade do |t|
    t.integer  "survey_id"
    t.integer  "survey_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ordering"
  end

  add_index "question_assignments", ["ordering"], name: "index_orderings_in_question_assignments", using: :btree

  create_table "question_details", force: :cascade do |t|
    t.integer  "survey_question_id"
    t.text     "details_list"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "respondents", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cookie_key"
  end

  create_table "responses", force: :cascade do |t|
    t.integer  "respondent_id"
    t.integer  "survey_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "closed"
  end

  create_table "survey_questions", force: :cascade do |t|
    t.integer  "question_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "question_prompt"
    t.string   "title"
    t.float    "budget"
  end

  create_table "surveys", force: :cascade do |t|
    t.string   "title"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
    t.text     "introduction"
    t.string   "owner_type"
    t.text     "thankyou_note"
    t.string   "public_link"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.string   "unconfirmed_email"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
