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

ActiveRecord::Schema[7.1].define(version: 2024_02_04_174807) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_dimensions", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.string "name"
    t.string "currency"
    t.datetime "stop_date"
    t.bigint "users_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_account_dimensions_on_id", unique: true
    t.index ["users_id"], name: "index_account_dimensions_on_users_id"
  end

  create_table "ad_accounts", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.string "name"
    t.string "currency"
    t.datetime "stop_date"
    t.bigint "users_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_ad_accounts_on_id", unique: true
    t.index ["users_id"], name: "index_ad_accounts_on_users_id"
  end

  create_table "ad_campaigns", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.string "name"
    t.string "objective"
    t.datetime "startdate"
    t.bigint "lifetime_budget"
    t.string "budgeting_type"
    t.string "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "id"], name: "index_ad_campaigns_on_account_id_and_id", unique: true
    t.index ["id"], name: "index_ad_campaigns_on_id", unique: true
  end

  create_table "ad_dimensions", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.string "name"
    t.string "type"
    t.string "format"
    t.datetime "start_date"
    t.string "adset_id", null: false
    t.string "adset_name"
    t.string "adset_goal"
    t.datetime "adset_date"
    t.integer "adset_daily_budget"
    t.integer "adset_lifetime_budget"
    t.string "adset_billing_event"
    t.string "campaign_id", null: false
    t.string "campaign_name"
    t.string "campaign_objective"
    t.datetime "campaign_startdate"
    t.bigint "campaign_lifetime_budget"
    t.string "campaign_budgeting_type"
    t.string "account_id", null: false
    t.string "account_name"
    t.string "account_currency"
    t.string "account_stop_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "adset_name"], name: "index_ad_dimensions_on_account_id_and_adset_name"
    t.index ["account_id", "campaign_name"], name: "index_ad_dimensions_on_account_id_and_campaign_name"
    t.index ["account_id", "id"], name: "index_ad_dimensions_on_account_id_and_id", unique: true
    t.index ["account_id", "name"], name: "index_ad_dimensions_on_account_id_and_name"
    t.index ["id"], name: "index_ad_dimensions_on_id", unique: true
  end

  create_table "ad_metrics", force: :cascade do |t|
    t.integer "clicks"
    t.integer "link_clicks"
    t.integer "comments"
    t.integer "impressions"
    t.integer "likes"
    t.float "spend"
    t.integer "reach"
    t.integer "link_click_impressions"
    t.float "link_click_cost"
    t.datetime "event_date", null: false
    t.string "ad_id", null: false
    t.string "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "event_date"], name: "index_ad_metrics_on_account_id_and_event_date"
    t.index ["ad_id", "event_date"], name: "index_ad_metrics_on_ad_id_and_event_date", unique: true
  end

  create_table "ad_sets", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.string "name"
    t.string "goal"
    t.datetime "date"
    t.integer "daily_budget"
    t.integer "lifetime_budget"
    t.string "billing_event"
    t.string "campaign_id", null: false
    t.string "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "campaign_id"], name: "index_ad_sets_on_account_id_and_campaign_id"
    t.index ["id"], name: "index_ad_sets_on_id", unique: true
  end

  create_table "adaccount_metrics", force: :cascade do |t|
    t.integer "clicks"
    t.integer "link_clicks"
    t.integer "comments"
    t.integer "impressions"
    t.integer "likes"
    t.integer "reach"
    t.float "spend"
    t.integer "link_click_impressions"
    t.float "link_click_cost"
    t.datetime "event_date", null: false
    t.string "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "event_date"], name: "index_adaccount_metrics_on_account_id_and_event_date", unique: true
  end

  create_table "adcampaign_metrics", force: :cascade do |t|
    t.integer "clicks"
    t.integer "link_clicks"
    t.integer "comments"
    t.integer "impressions"
    t.integer "likes"
    t.float "spend"
    t.integer "reach"
    t.integer "link_click_impressions"
    t.float "link_click_cost"
    t.datetime "event_date", null: false
    t.string "campaign_id", null: false
    t.string "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "event_date"], name: "index_adcampaign_metrics_on_account_id_and_event_date"
    t.index ["campaign_id", "event_date"], name: "index_adcampaign_metrics_on_campaign_id_and_event_date", unique: true
  end

  create_table "ads", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.string "name"
    t.string "type"
    t.string "format"
    t.datetime "start_date"
    t.string "adset_id", null: false
    t.string "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "id"], name: "index_ads_on_account_id_and_id"
    t.index ["id"], name: "index_ads_on_id", unique: true
  end

  create_table "adset_dimensions", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.string "name"
    t.string "goal"
    t.datetime "date"
    t.integer "daily_budget"
    t.integer "lifetime_budget"
    t.string "billing_event"
    t.string "campaign_id", null: false
    t.string "campaign_name"
    t.string "campaign_objective"
    t.datetime "campaign_startdate"
    t.bigint "campaign_lifetime_budget"
    t.string "campaign_budgeting_type"
    t.string "account_id", null: false
    t.string "account_name"
    t.string "account_currency"
    t.string "account_stop_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "id"], name: "index_adset_dimensions_on_account_id_and_id", unique: true
    t.index ["account_id", "name"], name: "index_adset_dimensions_on_account_id_and_name"
    t.index ["id"], name: "index_adset_dimensions_on_id", unique: true
  end

  create_table "adset_metrics", force: :cascade do |t|
    t.integer "clicks"
    t.integer "link_clicks"
    t.integer "comments"
    t.integer "impressions"
    t.integer "likes"
    t.float "spend"
    t.integer "reach"
    t.integer "link_click_impressions"
    t.float "link_click_cost"
    t.datetime "event_date", null: false
    t.string "adset_id", null: false
    t.string "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "event_date"], name: "index_adset_metrics_on_account_id_and_event_date"
    t.index ["adset_id", "event_date"], name: "index_adset_metrics_on_adset_id_and_event_date", unique: true
  end

  create_table "campaign_dimensions", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.string "name"
    t.string "objective"
    t.datetime "startdate"
    t.bigint "lifetime_budget"
    t.string "budgeting_type"
    t.string "account_id", null: false
    t.string "account_name"
    t.string "account_currency"
    t.string "account_stop_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "id"], name: "index_campaign_dimensions_on_account_id_and_id", unique: true
    t.index ["account_id", "name"], name: "index_campaign_dimensions_on_account_id_and_name"
    t.index ["id"], name: "index_campaign_dimensions_on_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "fb_useraccount_id"
    t.string "fb_access_token", limit: 1000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
