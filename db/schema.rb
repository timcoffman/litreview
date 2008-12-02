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

ActiveRecord::Schema.define(:version => 20081201165809) do

  create_table "document_review_reasons", :force => true do |t|
    t.integer  "document_review_id"
    t.integer  "reason_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_reviews", :force => true do |t|
    t.integer  "document_id"
    t.integer  "stage_reviewer_id"
    t.string   "disposition"
    t.datetime "when_reviewed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reviewer_sequence", :default => 0, :null => false
    t.integer  "reviewer_snooze",   :default => 0, :null => false
  end

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
    t.integer  "tag_id",                     :null => false
    t.integer  "document_id",                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "applied_by_user_id",         :null => false
    t.integer  "applied_in_review_stage_id", :null => false
  end

  create_table "documents", :force => true do |t|
    t.integer  "document_source_id"
    t.string   "pub_ident"
    t.string   "title"
    t.string   "authors"
    t.string   "when_published"
    t.text     "abstract"
    t.integer  "duplicate_of_document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "journal",                  :limit => 256
  end

  add_index "documents", ["document_source_id", "pub_ident"], :name => "pub_ident", :unique => true

  create_table "import", :primary_key => "PubId", :force => true do |t|
    t.string "DuplicateOf",       :limit => 64
    t.string "Source",            :limit => 16,  :null => false
    t.string "Author",            :limit => 512, :null => false
    t.string "Date",              :limit => 16,  :null => false
    t.string "Title",             :limit => 512, :null => false
    t.string "Journal",           :limit => 512, :null => false
    t.text   "Keyword"
    t.text   "Abstract",                         :null => false
    t.string "OfInterest_U1",     :limit => 32
    t.string "OfInterest_U2",     :limit => 32
    t.string "Tags_U1_R1",        :limit => 32
    t.string "Reason_U1_R1",      :limit => 64
    t.string "ReasonOther_U1_R1", :limit => 256
    t.string "Tags_U2_R1",        :limit => 32
    t.string "Reason_U2_R1",      :limit => 64
    t.string "ReasonOther_U2_R1", :limit => 256
    t.string "Tags_U1_R2",        :limit => 32
    t.string "Reason_U1_R2",      :limit => 64
    t.string "ReasonOther_U1_R2", :limit => 256
    t.string "Tags_U2_R2",        :limit => 32
    t.string "Reason_U2_R2",      :limit => 64
    t.string "ReasonOther_U2_R2", :limit => 256
  end

  create_table "import_reasons", :id => false, :force => true do |t|
    t.integer "review_stage_id",                             :null => false
    t.integer "stage_reviewer_id",                           :null => false
    t.integer "created_by_stage_reviewer_id"
    t.integer "document_id",                                 :null => false
    t.string  "Reason",                       :limit => 256, :null => false
  end

  add_index "import_reasons", ["stage_reviewer_id", "document_id", "created_by_stage_reviewer_id", "Reason"], :name => "stage_reviewer_id", :unique => true

  create_table "import_reviews", :id => false, :force => true do |t|
    t.integer "review_stage_id",                  :null => false
    t.integer "stage_reviewer_id",                :null => false
    t.integer "document_id",                      :null => false
    t.string  "Tags",              :limit => 32
    t.string  "Reason",            :limit => 64
    t.string  "ReasonOther",       :limit => 256
  end

  create_table "import_tags", :primary_key => "PubId", :force => true do |t|
  end

  create_table "managers", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
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
  end

  create_table "reasons", :force => true do |t|
    t.integer  "review_stage_id"
    t.integer  "created_by_stage_reviewer_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sequence"
  end

  create_table "review_stages", :force => true do |t|
    t.integer  "project_id"
    t.integer  "sequence"
    t.string   "name"
    t.text     "description"
    t.string   "gate_function"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stage_reviewers", :force => true do |t|
    t.integer  "review_stage_id"
    t.integer  "user_id"
    t.boolean  "is_project_manager"
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
    t.string   "identity_url",                    :null => false
    t.string   "email"
    t.boolean  "is_admin",     :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["identity_url"], :name => "index_users_on_identity_url", :unique => true

end
