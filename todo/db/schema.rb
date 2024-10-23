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

ActiveRecord::Schema[7.2].define(version: 2024_10_23_053617) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "board_item_tags", force: :cascade do |t|
    t.bigint "board_item_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_item_id"], name: "index_board_item_tags_on_board_item_id"
  end

  create_table "board_items", force: :cascade do |t|
    t.bigint "board_id", null: false
    t.string "name"
    t.integer "priority", default: 0, null: false
    t.datetime "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["board_id"], name: "index_board_items_on_board_id"
  end

  create_table "boards", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "last_access", precision: nil
    t.integer "access_count"
    t.boolean "active", default: true
    t.boolean "daily", default: false
    t.index ["active"], name: "index_boards_on_active"
    t.index ["last_access"], name: "index_boards_on_last_access"
    t.index ["title", "user_id"], name: "index_boards_on_title_and_user_id", unique: true
    t.index ["user_id"], name: "index_boards_on_user_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "board_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.boolean "completed"
    t.bigint "mood_id"
    t.datetime "completed_at"
    t.datetime "due_date"
    t.integer "priority"
    t.integer "reminders_sent", default: [], array: true
    t.index ["board_item_id"], name: "index_cards_on_board_item_id"
    t.index ["completed"], name: "index_cards_on_completed"
    t.index ["due_date"], name: "index_cards_on_due_date"
    t.index ["mood_id"], name: "index_cards_on_mood_id"
    t.index ["priority"], name: "index_cards_on_priority"
  end

  create_table "mood_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
  end

  create_table "moods", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parameters", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.text "content"
    t.string "salt_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_parameters_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.bigint "card_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_tags_on_card_id"
  end

  create_table "theme_mood_messages", force: :cascade do |t|
    t.bigint "theme_mood_id", null: false
    t.text "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["theme_mood_id"], name: "index_theme_mood_messages_on_theme_mood_id"
  end

  create_table "theme_moods", force: :cascade do |t|
    t.bigint "mood_category_id", null: false
    t.bigint "mood_id", null: false
    t.string "image_url"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mood_category_id"], name: "index_theme_moods_on_mood_category_id"
    t.index ["mood_id"], name: "index_theme_moods_on_mood_id"
  end

  create_table "user_moods", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "mood_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
    t.index ["mood_id"], name: "index_user_moods_on_mood_id"
    t.index ["user_id"], name: "index_user_moods_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "name", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "mood_category_id"
    t.boolean "show_recent_boards", default: true
    t.boolean "show_popular_boards", default: true
    t.boolean "show_daily_board", default: true
    t.boolean "show_card_priority", default: true
    t.boolean "show_card_due_date", default: true
    t.boolean "show_card_mood", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "board_item_tags", "board_items"
  add_foreign_key "boards", "users", name: "fk_user"
  add_foreign_key "cards", "board_items"
  add_foreign_key "cards", "moods"
  add_foreign_key "parameters", "users"
  add_foreign_key "tags", "cards"
  add_foreign_key "theme_mood_messages", "theme_moods"
  add_foreign_key "theme_moods", "mood_categories"
  add_foreign_key "theme_moods", "moods"
  add_foreign_key "user_moods", "moods"
  add_foreign_key "user_moods", "users"
end
