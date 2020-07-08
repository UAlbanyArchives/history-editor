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

ActiveRecord::Schema.define(version: 2020_07_08_182538) do

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "date"
    t.string "display_date"
    t.string "citation_text"
    t.string "citation_link"
    t.integer "citation_page"
    t.text "citation_description"
    t.string "representative_media"
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "internal_note"
    t.boolean "content_confirmed"
    t.boolean "formatted_correctly"
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

end
