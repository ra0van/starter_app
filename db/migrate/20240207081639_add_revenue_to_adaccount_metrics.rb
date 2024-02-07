class AddRevenueToAdaccountMetrics < ActiveRecord::Migration[7.1]
  def change
    add_column :adaccount_metrics, :revenue, :float
  end
end
