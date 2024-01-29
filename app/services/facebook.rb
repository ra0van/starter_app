# frozen_string_literal: true

require_relative 'request_handler'
require 'json'

# Class to interact with Facebook Ads API
class Facebook
  @@access_token = 'EAAKDX99BZAz4BO75vjcOZCaPL2NheZCcQYXskZB1ag6hn7hD70DtvsQf99V2tXxXg8cJDMby8ZABxvK2QhfPAi0WA9drlZBEzZCZAdraKXTOjYI7tzyWzSn1Lt0PxXdUtADzaG7mfZAidIRZAdDIPS6fGpBxyEvZC99rxLfPBQDh3sc015VOENmCHAb7M0S39gzDu0x'
  @@app_secret = '4fc406efd8e284f04bc46afa6fba6305'

  @@base_url = 'https://graph.facebook.com/'
  @@user_account_id = '236247562146310'
  @@account_id = 'act_202330961584003'
  @@version = 'v18.0'

  @@req_handler = HTTP::RequestHandler.new

  def get_ads(account_id)
    path_params = [@@base_url, @@version, account_id, 'ads']
    url = path_params.join('/')
    params = {
      access_token: @@access_token,
      limit: 2000,
      # date_preset:'yesterday',
      # TODO : Convert to enums & concat array to string
      fields: 'name, id, created_time, campaign_id, account_id, adset_id'
    }
    get(url, params)
  end

  def get_ad_sets(account_id)
    path_params = [@@base_url, @@version, account_id, 'adsets']
    url = path_params.join('/')
    params = {
      access_token: @@access_token,
      limit: 1000,
      # date_preset:'yesterday',
      # TODO : Convert to enums & concat array to string
      fields: 'name, id, created_time, campaign_id, account_id'
    }
    get(url, params)
  end

  def get_ad_campaigns(account_id)
    path_params = [@@base_url, @@version, account_id, 'campaigns']
    url = path_params.join('/')
    params = {
      access_token: @@access_token,
      limit: 1000,
      # date_preset:'yesterday',
      # TODO : Convert to enums & concat array to string
      fields: 'name, id, created_time, campaign_id, account_id'
    }
    get(url, params)
  end

  def get_ad_accounts(user_account_id)
    path_params = [@@base_url, @@version, user_account_id, 'adaccounts']
    url = path_params.join('/')
    params = {
      access_token: @@access_token,
      limit: 1000,
      # date_preset:'yesterday',
      # TODO : Convert to enums & concat array to string
      fields: 'name, id, currency'
    }
    get(url, params)
  end

  def get_account_insights(account_id)
    path_params = [@@base_url, @@version, account_id, 'insights']
    url = path_params.join('/')

    params = {
      access_token: @@access_token,
      limit: 10_000,
      date_preset: 'yesterday',
      fields: 'account_id,account_name,campaign_id,campaign_name,account_currency,reach,impressions,clicks,cpc,spend,inline_link_clicks,ctr,cost_per_unique_action_type,cpm,cpp',
      time_increment: 1,
      level: 'account'
    }
    get(url, params)
  end

  def get_ad_insights(account_id)
    path_params = [@@base_url, @@version, account_id, 'insights']
    url = path_params.join('/')

    params = {
      access_token: @@access_token,
      limit: 10_000,
      date_preset: 'yesterday',
      fields: 'account_id,account_name,account_currency,reach,impressions,clicks,cpc,spend,inline_link_clicks,ctr,ad_id,cpm,cpp',
      time_increment: 1,
      level: 'ad'
    }
    get(url, params)
  end

  def get(url, params)
    data = []
    continue = true
    loop do
      puts 'Sending Request : GET : ' + url
      response = @@req_handler.send_get_request(url, params)

      if response.code == '200'
        parsed_response = JSON.parse response.body
      else
        puts response.code
        puts response
        raise Exception.new 'Failed to fetch data'
      end

      data += parsed_response['data']

      if parsed_response['paging'].key? 'next'
        after = parsed_response['paging']['cursors']['after']
        params['after'] = after
      else
        continue = false
      end

      break if continue == false
    end
    puts 'Fetched ' + data.length.to_s + ' records'
    data
  end
end
