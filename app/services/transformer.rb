# frozen_string_literal: true

class Transformer
  def transform(username)
    user = Users.find_by(username: username)
    accounts = AdAccounts.where(users: user)
    transform_and_save_accounts(accounts)
    accounts.each do |account|
      campaigns = AdCampaigns.where(account_id: account['id']).to_a
      transform_and_save_campaigns(campaigns, account)
      adsets = AdSets.where(account_id: account['id'])
      transform_and_save_adsets(adsets, campaigns, account)
      ads = Ads.where(account_id: account['id'])
      transform_and_save_ads(ads, adsets, campaigns, account)
    end
  end

  def transform_and_save_accounts(accounts)
    puts 'Transforming accounts'
    account_dimensions = accounts.map do |account|
      {
        id: account['id'],
        name: account['name'],
        currency: account['currency'],
        users_id: account['users_id']
      }
    end

    AccountDimensions.upsert_all(account_dimensions, unique_by: :id)
    puts "Saved #{account_dimensions.length} records"
  end

  def transform_and_save_campaigns(campaigns, account)
    puts "Transforming campaigns for account id : #{account['id']}"
    campaign_dimensions = campaigns.map do |campaign|
      {
        id: campaign['id'],
        name: campaign['name'],
        objective: campaign['objective'],
        startdate: campaign['startdate'],
        lifetime_budget: campaign['lifetime_budget'],
        budgeting_type: campaign['budgeting_type'],
        account_id: account['id'],
        account_name: account['name'],
        account_currency: account['currency'],
        account_stop_date: account['stop_date']
      }
    end

    CampaignDimensions.upsert_all(campaign_dimensions, unique_by: :id)
    puts "Saved #{campaign_dimensions.length} records"
  end

  def transform_and_save_adsets(adsets, campaigns, account)
    puts "Transforming adsets for account id : #{account['id']}"
    adset_dimensions = adsets.map do |adset|
      obj = adset.attributes
      c = campaigns.find { |campaign| campaign['id'] = adset['campaign_id'] }
      obj['campaign_name'] = c['name']
      obj['campaign_objective'] = c['objective']
      obj['campaign_startdate'] = c['startdate']
      obj['campaign_lifetime_budget'] = c['lifetime_budget']
      obj['campaign_budgeting_type'] = c['budgeting_type']
      obj['account_name'] = account['name']
      obj['account_currency'] = account['currency']
      obj['account_stop_date'] = account['stop_date']
      obj
    end

    AdsetDimensions.upsert_all(adset_dimensions, unique_by: :id)
    puts "Saved #{adset_dimensions.length} records"
  end

  def transform_and_save_ads(ads, adsets, campaigns, account)
    puts "Transforming ads for account id : #{account['id']}"
    ad_dimensions = ads.map do |ad|
      obj = ad.attributes
      a = adsets.find { |adset| adset['id'] = ad['adset_id'] }
      c = campaigns.find { |campaign| campaign['id'] = a['campaign_id'] }
      obj['adset_name'] = a['name']
      obj['adset_goal'] = a['goal']
      obj['adset_date'] = a['adset_date']
      obj['adset_daily_budget'] = a['daily_budget']
      obj['adset_lifetime_budget'] = a['lifetime_budget']
      obj['adset_billing_event'] = a['billing_event']
      obj['campaign_id'] = c['id']
      obj['campaign_name'] = c['name']
      obj['campaign_objective'] = c['objective']
      obj['campaign_startdate'] = c['startdate']
      obj['campaign_lifetime_budget'] = c['lifetime_budget']
      obj['campaign_budgeting_type'] = c['budgeting_type']
      obj['account_name'] = account['name']
      obj['account_currency'] = account['currency']
      obj['account_stop_date'] = account['stop_date']
      obj
    end

    AdDimensions.upsert_all(ad_dimensions, unique_by: :id)
    puts "Saved #{ad_dimensions.length} records"
  end
end
