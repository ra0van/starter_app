class CreateAds < ActiveRecord::Migration[7.1]
  def change
    create_table :ads, :id => false, primary_key: :ad_id do |t|
      t.string          :id, null: false
      t.string          :name
      t.string          :type
      t.string          :format
      t.datetime        :start_date
      t.string          :adset_id, null: false
      t.string          :account_id, null: false
      t.timestamps

      t.index :id, unique: true
      t.index [:account_id, :id]
    end

    create_table :ads_metrics do |t|
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
      t.string      :ad_id, null: false
      t.string      :account_id, null: false
      t.timestamps

      t.index [:ad_id, :event_date], unique: true
      t.index [:account_id, :event_date]
    end
  end
end
