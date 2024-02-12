require 'csv'

class GA_Ingester
  def initialize(file_path)
    @file_path = file_path
  end

  def process_csv
    ga_revenue = []
    CSV.foreach(@file_path, headers: true).with_index(1) do |row, index|
      name = row['name']
      adset_name = row['adset_name']
      campaign_name = row['campaign_name']
      revenue = row['revenue']
      event_date = row['event_date']

      account_id = nil
      campaign_id = nil
      adset_id = nil
      ad_id = nil

      insert = false
      if !name.blank?
        ad = AdDimensions.find_by(name: name, adset_name: adset_name, campaign_name: campaign_name)
        if ad.present?
          account_id = ad.account_id
          campaign_id = ad.campaign_id
          adset_id = ad.adset_id
          ad_id = ad.id
          insert = true
        end
        # Similar logic for 'adset_name', checking for presence
      elsif !adset_name.blank?
        adset = AdsetDimensions.find_by(name: adset_name, campaign_name: campaign_name)
        if adset.present?
          account_id = adset.account_id
          campaign_id = adset.campaign_id
          adset_id = adset.id
          insert = true
        end
        # Similar logic for 'campaign_name', checking for presence
      elsif !campaign_name.blank?
        campaign = CampaignDimensions.find_by(name: campaign_name)
        if campaign.present?
          account_id = campaign.account_id
          campaign_id = campaign.id
          insert = true
        end
      end

      if insert
        row = {
          account_id:,
          campaign_id:,
          adset_id:,
          ad_id:,
          event_date:,
          revenue: revenue.to_f
        }

        ga_revenue.push(row)
      end
    end

    GoogleRevenues.upsert_all(ga_revenue)
  end
end
