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

ActiveRecord::Schema.define(version: 20180820084819) do

  create_table "advertisers", force: :cascade do |t|
    t.integer  "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_advertisers_on_profile_id"
  end

  create_table "blocks", force: :cascade do |t|
    t.text     "b_difficulty"
    t.text     "b_extraData"
    t.text     "b_gasLimit"
    t.text     "b_gasUsed"
    t.text     "b_hash"
    t.text     "b_logsBloom"
    t.text     "b_miner"
    t.text     "b_mixHash"
    t.text     "b_nonce"
    t.integer  "b_number"
    t.text     "b_parentHash"
    t.text     "b_receiptsRoot"
    t.text     "b_sha3Uncles"
    t.text     "b_size"
    t.text     "b_stateRoot"
    t.text     "b_timestamp"
    t.text     "b_totalDifficulty"
    t.string   "b_transactions"
    t.text     "b_transactionsRoot"
    t.text     "b_uncles"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["b_hash"], name: "index_blocks_on_b_hash"
    t.index ["b_number"], name: "index_blocks_on_b_number"
  end

  create_table "contracts", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.text     "abi"
    t.text     "code"
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

  create_table "transactions", force: :cascade do |t|
    t.text     "t_blockHash"
    t.text     "t_blockNumber"
    t.text     "t_from"
    t.text     "t_gas"
    t.text     "t_gasPrice"
    t.text     "t_hash"
    t.text     "t_input"
    t.text     "t_nonce"
    t.text     "t_to"
    t.text     "t_transactionIndex"
    t.text     "t_value"
    t.text     "t_contract_address"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["t_from"], name: "index_transactions_on_t_from"
    t.index ["t_hash"], name: "index_transactions_on_t_hash"
  end

end
