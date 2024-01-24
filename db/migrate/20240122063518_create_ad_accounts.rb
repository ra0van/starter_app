class CreateAdAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :ad_accounts, :id => false, primary_key: :ad_account_id do |t|
      t.string        :ad_account_id, null: false
      t.string        :ad_account_name
      t.string        :ad_account_currency
      t.datetime      :stop_date
      t.belongs_to    :users
      t.timestamps

      t.index :ad_account_id, unique: true
    end

    create_table :ad_accounts_metrics do |t|
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
      t.string      :ad_account_id, null: false
      t.timestamps

      t.index [:ad_account_id, :event_date], unique: true
    end
  end
end
