class CreateAdsetDimensions < ActiveRecord::Migration[7.1]
  def change
    create_table :adset_dimensions, :id => false, primary_key: :id do |t|
      t.string          :id, null: false
      t.string          :name
      t.string          :goal
      t.datetime        :date
      t.integer         :daily_budget
      t.integer         :lifetime_budget
      t.string          :billing_event
      t.string          :campaign_id, null: false
      t.string          :campaign_name
      t.string          :campaing_objective
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
    end
  end
end
