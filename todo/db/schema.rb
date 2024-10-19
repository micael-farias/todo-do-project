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

ActiveRecord::Schema[7.2].define(version: 2024_10_19_202603) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "board_cards", force: :cascade do |t|
    t.bigint "board_id", null: false
    t.bigint "card_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id", "card_id"], name: "index_board_cards_on_board_id_and_card_id", unique: true
    t.index ["board_id"], name: "index_board_cards_on_board_id"
    t.index ["card_id"], name: "index_board_cards_on_card_id"
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

  create_table "boards", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_access"
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
    t.index ["mood_id"], name: "index_cards_on_mood_id"
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

  create_table "user_moods", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "mood_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "board_cards", "boards"
  add_foreign_key "board_cards", "cards"
  add_foreign_key "board_item_tags", "board_items"
  add_foreign_key "board_items", "boards"
  add_foreign_key "boards", "users"
  add_foreign_key "cards", "board_items"
  add_foreign_key "cards", "moods"
  add_foreign_key "parameters", "users"
  add_foreign_key "tags", "cards"
  add_foreign_key "user_moods", "moods"
  add_foreign_key "user_moods", "users"
end
