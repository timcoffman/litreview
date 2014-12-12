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

ActiveRecord::Schema.define(:version => 20110214212423) do

  create_table "document_review_reasons", :force => true do |t|
    t.integer  "document_review_id"
    t.integer  "reason_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_reviews", :force => true do |t|
    t.integer  "document_id"
    t.integer  "stage_reviewer_id"
    t.integer  "reviewer_sequence", :default => 0
    t.integer  "reviewer_snooze",   :default => 0
    t.string   "disposition"
    t.datetime "when_reviewed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "document_reviews", ["disposition"], :name => "disposition"
  add_index "document_reviews", ["document_id"], :name => "document"
  add_index "document_reviews", ["document_id", "stage_reviewer_id"], :name => "document_and_stage_reviewer", :unique => true
  add_index "document_reviews", ["stage_reviewer_id"], :name => "stage_reviewer"

  create_table "document_sources", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.string   "identifier"
    t.string   "website"
    t.string   "query_url_template"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_tags", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "document_id"
    t.integer  "applied_by_user_id"
    t.integer  "applied_in_review_stage_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.integer  "document_source_id"
    t.string   "pub_ident"
    t.string   "title"
    t.string   "authors"
    t.string   "journal"
    t.string   "when_published"
    t.text     "abstract"
    t.integer  "duplicate_of_document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["document_source_id", "pub_ident"], :name => "index_documents_on_document_source_id_and_pub_ident", :unique => true

  create_table "import_mappings", :force => true do |t|
    t.integer  "document_source_id", :null => false
    t.string   "column_heading",     :null => false
    t.string   "document_attribute"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "import_mappings", ["column_heading", "document_source_id"], :name => "column_heading", :unique => true

  create_table "managers", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "observations", :force => true do |t|
    t.text     "location",                          :null => false
    t.text     "description",                       :null => false
    t.integer  "criticality",    :default => 3
    t.string   "classification", :default => "bug"
    t.string   "status",         :default => "new"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "keywords",    :limit => 1024
  end

  create_table "reasons", :force => true do |t|
    t.integer  "review_stage_id"
    t.integer  "created_by_stage_reviewer_id"
    t.string   "title"
    t.integer  "sequence"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "review_form_answers", :force => true do |t|
    t.integer  "document_review_id",             :null => false
    t.integer  "review_form_question_id",        :null => false
    t.integer  "review_form_possible_answer_id"
    t.string   "impromptu_answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "review_form_possible_answers", :force => true do |t|
    t.integer  "review_form_question_id", :null => false
    t.integer  "sequence"
    t.string   "possible_answer",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "review_form_possible_answers", ["review_form_question_id", "sequence"], :name => "rf_pa_sequence", :unique => true

  create_table "review_form_questions", :force => true do |t|
    t.integer  "review_form_id",         :null => false
    t.integer  "sequence"
    t.string   "question",               :null => false
    t.string   "answer_type",            :null => false
    t.boolean  "allow_impromptu_answer", :null => false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "review_form_questions", ["review_form_id", "sequence"], :name => "rf_q_sequence", :unique => true

  create_table "review_forms", :force => true do |t|
    t.integer  "review_stage_id", :null => false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "review_stages", :force => true do |t|
    t.integer  "project_id"
    t.integer  "sequence"
    t.string   "name"
    t.text     "description"
    t.string   "gate_function"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "keywords",      :limit => 1024
  end

  create_table "stage_reviewers", :force => true do |t|
    t.integer  "review_stage_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "words"
    t.integer  "created_by_user_id"
    t.integer  "created_for_project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_preferences", :force => true do |t|
    t.integer  "user_id"
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "full_name"
    t.string   "nickname"
    t.string   "identity_url",                          :null => false
    t.string   "email"
    t.boolean  "is_admin",           :default => false, :null => false
    t.integer  "current_project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["identity_url"], :name => "index_users_on_identity_url", :unique => true
  add_index "users", ["nickname"], :name => "index_users_on_nickname", :unique => true

end
