class AddRevenueToAdcampaignMetrics < ActiveRecord::Migration[7.1]
  def change
    add_column :adcampaign_metrics, :revenue, :float
  end
end
