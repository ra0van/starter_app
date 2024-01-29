# frozen_string_literal: true

require 'date'

# Class to transform facebook API data to ActiveRecord
class Transform
  def transform_ads(data)
    puts 'Transforming'
    ads = data.map do |record|
      {
        id: record['id'],
        name: record['name'],
        adset_id: record['adset_id'],
        account_id: record['account_id']
      }
    end
    puts 'Saving Records'
    Ads.upsert_all(ads, unique_by: :id)
  end

  def transform_ad_insights(data)
    ad_insights = data.map do |insight|
      {
        clicks: insight['clicks'],
        ctr: insight['ctr'],
        link_clicks: insight['inline_link_clicks'],
        event_date: Date.strptime(insight['date_stop'], '%Y-%m-%d'),
        comments: insight['comments'],
        spend: insight['spend'],
        ad_id: insight['ad_id'],
        account_id: insight['account_id']
      }
    end
    AdMetrics.upsert_all(ad_insights, unique_by: %i[ad_id event_date])
    # metrics = AdsMetrics.order('id').all
    # metrics.each { |x| puts x.inspect }
  end

  def transform_ad_sets(data)
    adsets = data.map do |set|
      {
        id: set['id'],
        name: set['name'],
        goal: set['optimization_goal'],
        daily_budget: set['daily_budget'],
        lifetime_budget: set['lifetime_budget'],
        billing_event: set['billing_event'],
        campaign_id: set['campaign_id'],
        account_id: set['account_id']
      }
    end

    AdSets.upsert_all(adsets, unique_by: :id)
  end

  def transform_adset_insights(data)
    ad_insights = data.map do |insight|
      {
        clicks: insight['clicks'],
        ctr: insight['ctr'],
        link_clicks: insight['inline_link_clicks'],
        event_date: Date.strptime(insight['date_stop'], '%Y-%m-%d'),
        comments: insight['comments'],
        spend: insight['spend'],
        adset_id: insight['adset_id'],
        account_id: insight['account_id']
      }
    end
    AdsetMetrics.upsert_all(ad_insights, unique_by: %i[adset_id event_date])
    # metrics = AdsMetrics.order('id').all
    # metrics.each { |x| puts x.inspect }
  end

  def transform_ad_campaigns(data)
    ad_campaigns = data.map do |campaign|
      adsets_data = campaign['adsets']
      if adsets_data.nil?
        lifetime_budget = 0
      else
        adsets = adsets_data['data']
        if adsets.nil?
          lifetime_budget = 0
        else
          lifetime_budget = adsets.sum { |adset| adset['lifetime_budget'].nil? ? 0 : adset['lifetime_budget'].to_i }
        end
      end

      {
        id: campaign['id'],
        name: campaign['name'],
        objective: campaign['objective'],
        startdate: Date.strptime(campaign['start_time'], '%Y-%m-%d'),
        # buying_type: campaign['buying_type'],
        account_id: campaign['account_id'],
        lifetime_budget: lifetime_budget
      }
    end

    AdCampaigns.upsert_all(ad_campaigns, unique_by: :id)
  end

  def transform_adcampaign_insights(data)
    campaign_insights = data.map do |insight|
      {
        clicks: insight['clicks'],
        ctr: insight['ctr'],
        link_clicks: insight['inline_link_clicks'],
        event_date: Date.strptime(insight['date_stop'], '%Y-%m-%d'),
        comments: insight['comments'],
        spend: insight['spend'],
        campaign_id: insight['campaign_id'],
        account_id: insight['account_id']
      }
    end

    AdcampaignMetrics.upsert_all(campaign_insights, unique_by: %i[campaign_id event_date])
  end

  def transform_ad_accounts(data)
    ad_accounts = data.map do |account|
      {
        id: account['id'],
        name: account['name'],
        currency: account['currency']
      }
    end

    AdAccounts.upsert_all(ad_accounts, unique_by: :id)
  end

  def transform_adaccount_insighs(data)
    account_insights = data.map do |insight|
      {
        clicks: insight['clicks'],
        ctr: insight['ctr'],
        link_clicks: insight['inline_link_clicks'],
        event_date: Date.strptime(insight['date_stop'], '%Y-%m-%d'),
        comments: insight['comments'],
        spend: insight['spend'],
        account_id: insight['account_id']
      }
    end

    AdaccountMetrics.upsert_all(account_insights, unique_by: %i[account_id event_date])
  end
end
