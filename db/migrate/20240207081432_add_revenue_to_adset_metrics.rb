class AddRevenueToAdsetMetrics < ActiveRecord::Migration[7.1]
  def change
    add_column :adset_metrics, :revenue, :float
  end
end
