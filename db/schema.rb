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

ActiveRecord::Schema[7.1].define(version: 2024_02_08_201706) do
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

  create_table "employees", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone", null: false
    t.string "email", null: false
    t.string "location"
    t.text "skills", default: [], array: true
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "age"
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["phone"], name: "index_employees_on_phone", unique: true
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
    t.string "name", null: false
    t.string "location", null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.string "image"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_farms_on_email", unique: true
    t.index ["phone"], name: "index_farms_on_phone", unique: true
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

  add_foreign_key "accommodations", "farms"
  add_foreign_key "experiences", "employees"
  add_foreign_key "posting_employees", "employees"
  add_foreign_key "posting_employees", "postings"
  add_foreign_key "postings", "farms"
  add_foreign_key "references", "employees"
end
