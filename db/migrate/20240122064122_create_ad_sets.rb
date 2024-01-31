class CreateAdSets < ActiveRecord::Migration[7.1]
  def change
    create_table :ad_sets, :id => false, primary_key: :ad_set_id do |t|
      t.string          :id, null: false
      t.string          :name
      t.string          :goal
      t.datetime        :date
      t.integer         :daily_budget
      t.integer         :lifetime_budget
      t.string          :billing_event
      t.string          :campaign_id, null: false
      t.string          :account_id, null: false
      t.timestamps

      t.index :id, unique: true
      t.index [:account_id, :campaign_id]
    end

    create_table :adset_metrics do |t|
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
      t.string      :adset_id, null: false
      t.string      :account_id, null: false
      t.timestamps

      t.index [:adset_id, :event_date], unique: true
      t.index [:account_id, :event_date]
    end
  end
end
