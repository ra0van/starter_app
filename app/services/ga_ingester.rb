require 'csv'

class GA_Ingester
  def initialize(file_path)
    @file_path = file_path
  end

  def process_csv
    CSV.foreach(@file_path, headers: true).with_index(1) do |row, index|
      name = row['name']
      adset_name = row['adset_name']
      campaign_name = row['campaign_name']
      revenue = row['revenue']
      event_date = row['event_date']

      # Process records with 'name' and ensure it's not null or empty
      if !name.blank?
        ad = AdDimensions.find_by(name: name)
        if ad.present?
          ad_metric = AdMetrics.find_or_initialize_by(ad_id: ad.id, event_date: event_date)
          puts ad_metric.inspect
          ad_metric.revenue = revenue.to_f if revenue.present?
          ad_metric.save
        end
      # Similar logic for 'adset_name', checking for presence
      elsif !adset_name.blank?
        adset = AdsetDimensions.find_by(name: adset_name)
        if adset.present?
          adset_metric = AdsetMetrics.find_or_initialize_by(adset_id: adset.id, event_date: event_date)
          puts adset_metric.inspect
          adset_metric.revenue = revenue.to_f if revenue.present?
          adset_metric.save
        end
      # Similar logic for 'campaign_name', checking for presence
      elsif !campaign_name.blank?
        campaign = CampaignDimensions.find_by(name: campaign_name)
        if campaign.present?
          campaign_metric = AdcampaignMetrics.find_or_initialize_by(campaign_id: campaign.id, event_date: event_date)
          puts campaign_metric.inspect
          campaign_metric.revenue = revenue.to_f if revenue.present?
          campaign_metric.save
        end
      end
    end
  end
end

