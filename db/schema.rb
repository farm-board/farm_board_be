# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_11_20_002109) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accommodations", force: :cascade do |t|
    t.boolean "housing"
    t.boolean "transportation"
    t.boolean "meals"
    t.string "images"
    t.bigint "farm_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farm_id"], name: "index_accommodations_on_farm_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.text "skills", default: [], array: true
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "age"
    t.bigint "user_id", null: false
    t.string "phone"
    t.string "email"
    t.string "image"
    t.boolean "setup_complete", default: false
    t.string "marketplace_phone"
    t.string "marketplace_email"
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "experiences", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.string "company_name", null: false
    t.string "started_at", null: false
    t.string "ended_at", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_experiences_on_employee_id"
  end

  create_table "farms", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "image"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.json "gallery_photos"
    t.boolean "setup_complete", default: false
    t.string "marketplace_phone"
    t.string "marketplace_email"
    t.index ["user_id"], name: "index_farms_on_user_id"
  end

  create_table "marketplace_postings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.string "price"
    t.string "description"
    t.string "condition"
    t.string "images"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_marketplace_postings_on_user_id"
  end

  create_table "posting_employees", force: :cascade do |t|
    t.bigint "posting_id", null: false
    t.bigint "employee_id", null: false
    t.string "notification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_posting_employees_on_employee_id"
    t.index ["posting_id"], name: "index_posting_employees_on_posting_id"
  end

  create_table "postings", force: :cascade do |t|
    t.bigint "farm_id", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.string "salary", null: false
    t.boolean "offers_lodging", null: false
    t.string "images"
    t.text "skill_requirements", default: [], array: true
    t.string "duration", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "age_requirement"
    t.string "payment_type"
    t.index ["farm_id"], name: "index_postings_on_farm_id"
  end

  create_table "references", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone"
    t.string "email"
    t.string "relationship", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_references_on_employee_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.integer "role_type", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accommodations", "farms"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "employees", "users"
  add_foreign_key "experiences", "employees"
  add_foreign_key "farms", "users"
  add_foreign_key "marketplace_postings", "users"
  add_foreign_key "posting_employees", "employees"
  add_foreign_key "posting_employees", "postings"
  add_foreign_key "postings", "farms"
  add_foreign_key "references", "employees"
end
