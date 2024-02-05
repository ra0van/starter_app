class CreateAdDimensions < ActiveRecord::Migration[7.1]
  def change
    create_table :ad_dimensions, :id => false, primary_key: :id do |t|
      t.string          :id, null: false
      t.string          :name
      t.string          :type
      t.string          :format
      t.datetime        :start_date
      t.string          :adset_id, null: false
      t.string          :adset_name
      t.string          :adset_goal
      t.datetime        :adset_date
      t.integer         :adset_daily_budget
      t.integer         :adset_lifetime_budget
      t.string          :adset_billing_event
      t.string          :campaign_id, null: false
      t.string          :campaign_name
      t.string          :campaign_objective
      t.datetime        :campaign_startdate
      t.bigint          :campaign_lifetime_budget
      t.string          :campaign_budgeting_type
      t.string          :account_id, null: false
      t.string          :account_name
      t.string          :account_currency
      t.string          :account_stop_date
      t.timestamps

      t.index :id, unique: true
      t.index [:account_id, :id], unique: true
      t.index [:account_id, :name]
      t.index [:account_id, :campaign_name]
      t.index [:account_id, :adset_name]
    end
  end
end
