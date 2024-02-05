# frozen_string_literal: true

require 'date'

# Class to transform Facebook API data to ActiveRecord
class Extractor
  REQUIRED_FIELDS = {
    ads: %w[id name adset_id account_id],
    ad_insights: %w[ad_id account_id date_stop],
    ad_sets: %w[id name account_id campaign_id],
    adset_insights: %w[adset_id account_id date_stop],
    ad_campaigns: %w[id name account_id],
    adcampaign_insights: %w[campaign_id account_id date_stop],
    ad_accounts: %w[id name],
    adaccount_insights: %w[account_id date_stop]
  }.freeze

  def extract_and_save_ads(data)
    puts 'Transforming Ads'
    ads = data.map do |record|
      validate_required_fields(record, REQUIRED_FIELDS[:ads])

      {
        id: record['id'],
        name: record['name'],
        adset_id: record['adset_id'],
        account_id: record['account_id']
      }
    end
    puts 'Saving Ads Records'
    Ads.upsert_all(ads, unique_by: :id)
  end

  def extract_and_save_ad_insights(data)
    puts 'Transforming Ad Insights'
    ad_insights = data.map do |insight|
      validate_required_fields(insight, REQUIRED_FIELDS[:ad_insights])

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
    puts 'Saving Ad Insights Records'
    AdMetrics.upsert_all(ad_insights, unique_by: %i[ad_id event_date])
    # metrics = AdsMetrics.order('id').all
    # metrics.each { |x| puts x.inspect }
  end

  def extract_and_save_ad_sets(data)
    puts 'Transforming Ad Sets'
    adsets = data.map do |set|
      validate_required_fields(set, REQUIRED_FIELDS[:ad_sets])

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

    puts 'Saving Ad Sets Records'
    AdSets.upsert_all(adsets, unique_by: :id)
  end

  def extract_and_save_adset_insights(data)
    puts 'Transforming Adset Insights'
    adset_insights = data.map do |insight|
      validate_required_fields(insight, REQUIRED_FIELDS[:adset_insights])

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

    puts 'Saving Adset Insights Records'
    AdsetMetrics.upsert_all(adset_insights, unique_by: %i[adset_id event_date])
  end

  def extract_and_save_ad_campaigns(data)
    puts 'Transforming Ad Campaigns'
    ad_campaigns = data.map do |campaign|
      validate_required_fields(campaign, REQUIRED_FIELDS[:ad_campaigns])

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
        account_id: campaign['account_id'],
        lifetime_budget: lifetime_budget
      }
    end

    puts 'Saving Ad Campaigns Records'
    AdCampaigns.upsert_all(ad_campaigns, unique_by: :id)
  end

  def extract_and_save_adcampaign_insights(data)
    puts 'Transforming Adcampaign Insights'
    campaign_insights = data.map do |insight|
      validate_required_fields(insight, REQUIRED_FIELDS[:adcampaign_insights])

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

    puts 'Saving Adcampaign Insights Records'
    AdcampaignMetrics.upsert_all(campaign_insights, unique_by: %i[campaign_id event_date])
  end

  def extract_and_save_ad_accounts(data, user_id)
    puts 'Transforming Ad Accounts'
    ad_accounts = data.map do |account|
      validate_required_fields(account, REQUIRED_FIELDS[:ad_accounts])
      {
        id: account['account_id'],
        name: account['name'],
        currency: account['currency'],
        users_id: user_id
      }
    end

    puts 'Saving Ad Accounts Records'
    AdAccounts.upsert_all(ad_accounts, unique_by: :id)
  end

  def extract_and_save_adaccount_insights(data)
    puts 'Transforming Adaccount Insights'
    account_insights = data.map do |insight|
      validate_required_fields(insight, REQUIRED_FIELDS[:adaccount_insights])

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

    puts 'Saving Adaccount Insights Records'
    AdaccountMetrics.upsert_all(account_insights, unique_by: %i[account_id event_date])
  end

  # Helper method to validate presence of required fields
  def validate_required_fields(data, required_fields)
    required_fields.each do |field|
      if data[field].nil? || data[field].empty?
        raise ArgumentError, "Missing or null value for required field: #{field}"
      end
    end
  end
end
