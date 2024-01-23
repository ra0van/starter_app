class CreateAdCampaigns < ActiveRecord::Migration[7.1]
  def change
    create_table :ad_campaigns, :id => false, primary_key: :ad_campaign_id do |t| 
      t.string        :ad_campaign_id, null: false
      t.string        :ad_campaign_name
      t.string        :ad_campaign_objective
      t.datetime      :ad_campaign_startdate
      t.integer       :ad_campaign_lifetime_budget
      t.string        :ad_campaign_budgeting_type
      t.string        :ad_account_id, null: false
      t.timestamps

      t.index [:ad_campaign_id,:ad_account_id], unique:true
    end

    create_table :ad_campaigns_metrics do |t|
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
      t.string      :ad_campaign_id, null: false
      t.string      :ad_account_id, null: false
      t.timestamps

      t.index [:ad_campaign_id, :event_date], unique: true
      t.index [:ad_account_id, :event_date]
    end
  end
end
