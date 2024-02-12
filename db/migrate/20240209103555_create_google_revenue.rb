class CreateGoogleRevenue < ActiveRecord::Migration[7.1]
  def change
    create_table :google_revenues do |t|
      t.string        :account_id
      t.string        :campaign_id
      t.string        :adset_id
      t.string        :ad_id
      t.float         :revenue
      t.datetime      :event_date
      t.timestamps

      t.index [:account_id, :campaign_id, :adset_id, :ad_id, :event_date], unique: true
    end
  end
end
