class CreateAdCampaigns < ActiveRecord::Migration[7.1]
  def change
    create_table :ad_campaigns, :id => false, primary_key: :ad_campaign_id do |t|
      t.string        :id, null: false
      t.string        :name
      t.string        :objective
      t.datetime      :startdate
      t.integer       :lifetime_budget
      t.string        :budgeting_type
      t.string        :account_id, null: false
      t.timestamps

      t.index :id, unique: true
      t.index [:account_id, :id], unique: true
    end

    create_table :adcampaign_metrics do |t|
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
      t.string      :campaign_id, null: false
      t.string      :account_id, null: false
      t.timestamps

      t.index [:campaign_id, :event_date], unique: true
      t.index [:account_id, :event_date]
    end
  end
end
