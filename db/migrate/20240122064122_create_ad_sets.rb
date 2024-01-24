class CreateAdSets < ActiveRecord::Migration[7.1]
  def change
    create_table :ad_sets, :id => false, primary_key: :ad_set_id do |t| 
      t.string          :ad_set_id, null:false
      t.string          :ad_set_name
      t.string          :ad_set_goal
      t.datetime        :ad_set_start_date
      t.integer         :ad_set_daily_budget
      t.integer         :ad_set_lifetime_budget
      t.string          :ad_set_billing_event
      t.string          :ad_campaign_id, null:false
      t.string          :ad_account_id, null:false
      t.timestamps

      t.index :ad_set_id, unique: true
      t.index [:ad_account_id, :ad_campaign_id] 
    end

    create_table :ad_sets_metrics do |t|
      t.integer     :clicks
      t.float       :ctr
      t.integer     :link_clicks
      t.float       :linl_clicks_ctr
      t.float       :cost_per_link_clicks
      t.integer     :comments
      t.integer     :impressions
      t.integer     :likes
      t.float       :spend
      t.datetime    :event_date, null: false
      t.string      :ad_set_id, null: false
      t.string      :ad_account_id, null: false
      t.timestamps

      t.index [:ad_set_id, :event_date], unique: true
      t.index [:ad_account_id, :event_date]
    end
  end
end
