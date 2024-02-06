class CreateAdCampaigns < ActiveRecord::Migration[7.1]
  def change
    create_table :ad_campaigns, :id => false, primary_key: :ad_campaign_id do |t|
      t.string        :id, null: false
      t.string        :name
      t.string        :objective
      t.datetime      :startdate
      t.bigint        :lifetime_budget
      t.string        :budgeting_type
      t.string        :account_id, null: false
      t.timestamps

      t.index :id, unique: true
      t.index [:account_id, :id], unique: true
    end

    create_table :adcampaign_metrics do |t|
      t.integer     :clicks
      t.integer     :link_clicks
      t.integer     :comments
      t.integer     :impressions
      t.integer     :likes
      t.float       :spend
      t.integer     :reach
      t.integer     :link_click_impressions
      t.float       :link_click_cost
      t.datetime    :event_date, null: false
      t.string      :campaign_id, null: false
      t.string      :account_id, null: false
      t.timestamps

      t.index [:campaign_id, :event_date], unique: true
      t.index [:account_id, :event_date]
    end
  end
end
