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

ActiveRecord::Schema[8.1].define(version: 2026_04_04_170829) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "analytics_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "event_type"
    t.jsonb "payload"
    t.string "session_id"
    t.datetime "updated_at", null: false
  end

  create_table "leads", force: :cascade do |t|
    t.jsonb "answers"
    t.text "comment"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "page_url"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.string "utm_campaign"
    t.string "utm_content"
    t.string "utm_medium"
    t.string "utm_source"
    t.string "utm_term"
    t.index ["answers"], name: "index_leads_on_answers", using: :gin
    t.index ["created_at"], name: "index_leads_on_created_at"
    t.index ["phone"], name: "index_leads_on_phone"
  end
end
