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

ActiveRecord::Schema[7.1].define(version: 2024_01_22_064126) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ad_accounts", id: false, force: :cascade do |t|
    t.string "ad_account_id", null: false
    t.string "ad_account_name"
    t.string "ad_account_currency"
    t.datetime "stop_date"
    t.bigint "users_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_account_id"], name: "index_ad_accounts_on_ad_account_id", unique: true
    t.index ["users_id"], name: "index_ad_accounts_on_users_id"
  end

  create_table "ad_accounts_metrics", force: :cascade do |t|
    t.integer "clicks"
    t.float "ctr"
    t.integer "link_clicks"
    t.float "linl_clicks_ctr"
    t.float "cost_per_link_clicks"
    t.integer "comments"
    t.integer "impressions"
    t.integer "likes"
    t.float "spend"
    t.datetime "event_date", null: false
    t.string "ad_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_account_id", "event_date"], name: "index_ad_accounts_metrics_on_ad_account_id_and_event_date", unique: true
  end

  create_table "ad_campaigns", id: false, force: :cascade do |t|
    t.string "ad_campaign_id", null: false
    t.string "ad_campaign_name"
    t.string "ad_campaign_objective"
    t.datetime "ad_campaign_startdate"
    t.integer "ad_campaign_lifetime_budget"
    t.string "ad_campaign_budgeting_type"
    t.string "ad_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_campaign_id", "ad_account_id"], name: "index_ad_campaigns_on_ad_campaign_id_and_ad_account_id", unique: true
  end

  create_table "ad_campaigns_metrics", force: :cascade do |t|
    t.integer "clicks"
    t.float "ctr"
    t.integer "link_clicks"
    t.float "linl_clicks_ctr"
    t.float "cost_per_link_clicks"
    t.integer "comments"
    t.integer "impressions"
    t.integer "likes"
    t.float "spend"
    t.datetime "event_date", null: false
    t.string "ad_campaign_id", null: false
    t.string "ad_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_account_id", "event_date"], name: "index_ad_campaigns_metrics_on_ad_account_id_and_event_date"
    t.index ["ad_campaign_id", "event_date"], name: "index_ad_campaigns_metrics_on_ad_campaign_id_and_event_date", unique: true
  end

  create_table "ad_sets", id: false, force: :cascade do |t|
    t.string "ad_set_id", null: false
    t.string "ad_set_name"
    t.string "ad_set_goal"
    t.datetime "ad_set_start_date"
    t.integer "ad_set_daily_budget"
    t.integer "ad_set_lifetime_budget"
    t.string "ad_set_billing_event"
    t.string "ad_campaign_id", null: false
    t.string "ad_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_campaign_id", "ad_account_id"], name: "index_ad_sets_on_ad_campaign_id_and_ad_account_id"
    t.index ["ad_set_id"], name: "index_ad_sets_on_ad_set_id", unique: true
  end

  create_table "ad_sets_metrics", force: :cascade do |t|
    t.integer "clicks"
    t.float "ctr"
    t.integer "link_clicks"
    t.float "linl_clicks_ctr"
    t.float "cost_per_link_clicks"
    t.integer "comments"
    t.integer "impressions"
    t.integer "likes"
    t.float "spend"
    t.datetime "event_date", null: false
    t.string "ad_set_id", null: false
    t.string "ad_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_account_id", "event_date"], name: "index_ad_sets_metrics_on_ad_account_id_and_event_date"
    t.index ["ad_set_id", "event_date"], name: "index_ad_sets_metrics_on_ad_set_id_and_event_date", unique: true
  end

  create_table "ads", id: false, force: :cascade do |t|
    t.string "ad_id", null: false
    t.string "ad_name"
    t.string "ad_type"
    t.string "ad_format"
    t.datetime "ad_start_date"
    t.string "ad_set_id", null: false
    t.string "ad_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_id"], name: "index_ads_on_ad_id", unique: true
    t.index ["ad_set_id", "ad_account_id"], name: "index_ads_on_ad_set_id_and_ad_account_id"
  end

  create_table "ads_metrics", force: :cascade do |t|
    t.integer "clicks"
    t.float "ctr"
    t.integer "link_clicks"
    t.float "linl_clicks_ctr"
    t.float "cost_per_link_clicks"
    t.integer "comments"
    t.integer "impressions"
    t.integer "likes"
    t.float "spend"
    t.datetime "event_date", null: false
    t.string "ad_id", null: false
    t.string "ad_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_account_id", "event_date"], name: "index_ads_metrics_on_ad_account_id_and_event_date"
    t.index ["ad_id", "event_date"], name: "index_ads_metrics_on_ad_id_and_event_date", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "fb_useraccount_id"
    t.string "fb_access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
