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

ActiveRecord::Schema.define(version: 2023_03_29_141445) do

  create_table "citations", force: :cascade do |t|
    t.string "text"
    t.string "link"
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "page"
    t.integer "event_id"
    t.index ["event_id"], name: "index_citations_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "date"
    t.string "display_date"
    t.text "citation_description"
    t.string "representative_media"
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "internal_note"
    t.boolean "content_confirmed"
    t.boolean "formatted_correctly"
    t.boolean "iiif"
    t.boolean "published"
    t.integer "updated_by"
  end

  create_table "events_subjects", id: false, force: :cascade do |t|
    t.integer "subject_id", null: false
    t.integer "event_id", null: false
    t.index ["event_id", "subject_id"], name: "index_events_subjects_on_event_id_and_subject_id"
    t.index ["subject_id", "event_id"], name: "index_events_subjects_on_subject_id_and_event_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "representative_media"
    t.string "file"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_active"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", limit: 8, null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 1073741823
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
