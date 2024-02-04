class CreateCampaignDimension < ActiveRecord::Migration[7.1]
  def change
    create_table :campaign_dimensions, :id => false, primary_key: :id do |t|
      t.string        :id, null: false
      t.string        :name
      t.string        :objective
      t.datetime      :startdate
      t.bigint        :lifetime_budget
      t.string        :budgeting_type
      t.string        :account_id, null: false
      t.string        :account_name
      t.string        :account_currency
      t.string        :account_stop_date
      t.timestamps

      t.index :id, unique: true
      t.index [:account_id, :id], unique: true
      t.index [:account_id, :name]
    end
  end
end
