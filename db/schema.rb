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

ActiveRecord::Schema.define(version: 20180802084606) do

  create_table "advertisers", force: :cascade do |t|
    t.integer  "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_advertisers_on_profile_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.text     "abi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ethereum_wallets", force: :cascade do |t|
    t.string   "public_hex"
    t.string   "private_hex"
    t.string   "address"
    t.integer  "userable_id"
    t.string   "userable_type", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["userable_id"], name: "index_ethereum_wallets_on_userable_id"
  end

  create_table "owners", force: :cascade do |t|
    t.integer  "profile_id"
    t.integer  "referrer_id"
    t.string   "contract_address"
    t.boolean  "root"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["profile_id"], name: "index_owners_on_profile_id"
    t.index ["referrer_id"], name: "index_owners_on_referrer_id"
  end

end
