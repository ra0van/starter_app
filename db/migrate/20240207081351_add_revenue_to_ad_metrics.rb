class AddRevenueToAdMetrics < ActiveRecord::Migration[7.1]
  def change
    add_column :ad_metrics, :revenue, :float
  end
end
