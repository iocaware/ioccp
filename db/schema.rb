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

ActiveRecord::Schema.define(:version => 20130922001147) do

  create_table "agent_settings", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "agents", :force => true do |t|
    t.string   "aid"
    t.string   "ip"
    t.string   "mac"
    t.string   "hostname"
    t.string   "target"
    t.string   "os"
    t.string   "osv"
    t.string   "hmac"
    t.datetime "lastcheck"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "agent_id"
  end

  create_table "agents_jobs", :force => true do |t|
    t.integer "agent_id"
    t.integer "job_id"
    t.integer "status"
  end

  add_index "agents_jobs", ["agent_id", "job_id"], :name => "index_agents_jobs_on_agent_id_and_job_id"

  create_table "alerts", :force => true do |t|
    t.boolean  "urgent"
    t.boolean  "acknowleged"
    t.integer  "user_acknowledged"
    t.string   "reason"
    t.text     "actionplan"
    t.integer  "results_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "agent_id"
    t.integer  "job_id"
  end

  add_index "alerts", ["acknowleged"], :name => "index_alerts_on_acknowleged"
  add_index "alerts", ["results_id"], :name => "index_alerts_on_results_id"
  add_index "alerts", ["urgent"], :name => "index_alerts_on_urgent"

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

# Could not dump table "indicator_results" because of following StandardError
#   Unknown type 'results_id' for column 'integer'

  create_table "iocs", :force => true do |t|
    t.string   "iid"
    t.string   "name"
    t.string   "description"
    t.string   "author"
    t.string   "content"
    t.string   "path"
    t.string   "publicpath"
    t.string   "source"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "iocs_jobs", :force => true do |t|
    t.integer "ioc_id"
    t.integer "job_id"
  end

  add_index "iocs_jobs", ["job_id", "ioc_id"], :name => "index_iocs_jobs_on_job_id_and_ioc_id"

  create_table "job_statuses", :force => true do |t|
    t.string   "job_id"
    t.string   "agent_id"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.datetime "start_on"
    t.datetime "end_on"
    t.string   "target"
    t.string   "repeat"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "jid"
  end

  create_table "jobs_iocs", :force => true do |t|
    t.integer "job_id"
    t.integer "ioc_id"
  end

  add_index "jobs_iocs", ["job_id", "ioc_id"], :name => "index_jobs_iocs_on_job_id_and_ioc_id"

# Could not dump table "results" because of following StandardError
#   Unknown type 'ioc' for column 'string'

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "password_digest"
    t.string   "email"
    t.boolean  "read_only"
    t.boolean  "isadmin"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
