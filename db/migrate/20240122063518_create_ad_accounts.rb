# frozen_string_literal: true

class CreateAdAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :ad_accounts, :id => false, primary_key: :ad_account_id do |t|
      t.string        :id, null: false
      t.string        :name
      t.string        :currency
      t.datetime      :stop_date
      t.belongs_to    :users
      t.timestamps

      t.index :id, unique: true
    end

    create_table :adaccount_metrics do |t|
      t.integer     :clicks
      t.integer     :link_clicks
      t.integer     :comments
      t.integer     :impressions
      t.integer     :likes
      t.integer     :reach
      t.float       :spend
      t.integer     :link_click_impressions
      t.float       :link_click_cost
      t.datetime    :event_date, null: false
      t.string      :account_id, null: false
      t.timestamps

      t.index %i[account_id event_date], unique: true
    end
  end
end
