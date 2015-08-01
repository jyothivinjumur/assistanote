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

ActiveRecord::Schema.define(version: 20150726131103) do

  create_table "attachments", force: true do |t|
    t.string   "reference_id"
    t.string   "path"
    t.integer  "email_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content"
  end

  add_index "attachments", ["email_id"], name: "index_attachments_on_email_id", using: :btree

  create_table "emails", force: true do |t|
    t.string   "reference_id"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.text     "content"
  end

  add_index "emails", ["category"], name: "index_emails_on_category", using: :btree

  create_table "emails_evaluations", force: true do |t|
    t.integer "email_id"
    t.integer "evaluation_id"
  end

  add_index "emails_evaluations", ["email_id"], name: "index_emails_evaluations_on_email_id", using: :btree
  add_index "emails_evaluations", ["evaluation_id"], name: "index_emails_evaluations_on_evaluation_id", using: :btree

  create_table "evaluations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "evaluations_users", force: true do |t|
    t.integer "evaluation_id"
    t.integer "user_id"
  end

  add_index "evaluations_users", ["evaluation_id"], name: "index_evaluations_users_on_evaluation_id", using: :btree
  add_index "evaluations_users", ["user_id"], name: "index_evaluations_users_on_user_id", using: :btree

  create_table "histories", force: true do |t|
    t.integer  "node"
    t.date     "sent_date"
    t.decimal  "score",      precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "histories", ["node"], name: "index_histories_on_node", using: :btree
  add_index "histories", ["sent_date"], name: "index_histories_on_sent_date", using: :btree

  create_table "interactions", force: true do |t|
    t.integer  "sender"
    t.integer  "receiver"
    t.text     "comm"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prnodes", force: true do |t|
    t.integer  "pgid"
    t.string   "pgnodename"
    t.decimal  "pgscore",       precision: 10, scale: 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "relative_rank", precision: 10, scale: 2
    t.string   "Role"
  end

  add_index "prnodes", ["pgid"], name: "index_prnodes_on_pgid", using: :btree
  add_index "prnodes", ["pgnodename"], name: "index_prnodes_on_pgnodename", using: :btree

  create_table "relations", force: true do |t|
    t.string   "email"
    t.integer  "node"
    t.string   "recipient"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "email_id"
  end

  create_table "termscores", force: true do |t|
    t.string   "term"
    t.decimal  "score",      precision: 10, scale: 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "termscores", ["term"], name: "index_termscores_on_term", using: :btree

  create_table "users", force: true do |t|
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
    t.string   "username"
    t.string   "user_type"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["user_type"], name: "index_users_on_user_type", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["votable_id"], name: "index_votes_on_votable_id", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

end
