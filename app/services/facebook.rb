# frozen_string_literal: true

require_relative 'request_handler'
require 'json'

# Class to interact with Facebook Ads API
class Facebook
  def initialize(access_token)
    @access_token = access_token
    @req_handler = HTTP::RequestHandler.new
  end

  BASE_URL = 'https://graph.facebook.com/'
  VERSION = 'v18.0'
  FIELDS = {
    ads: %w[name id created_time campaign_id account_id adset_id],
    adsets: %w[name id created_time campaign_id account_id],
    campaigns: %w[objective name id buying_type daily_budget lifetime_budget start_time account_id adsets.fields(daily_budget lifetime_budget) budgeting_type],
    adaccounts: %w[name account_id currency],
    account_insights: %w[account_id reach impressions clicks cpc spend inline_link_clicks ctr cost_per_unique_action_type cpm cpp],
    campaign_insights: %w[account_id account_name campaign_id campaign_name account_currency reach impressions clicks cpc spend inline_link_clicks],
    adset_insights: %w[account_id account_currency reach impressions clicks cpc spend inline_link_clicks adset_id],
    ad_insights: %w[account_id account_name account_currency reach impressions clicks cpc spend inline_link_clicks ctr ad_id cpm cpp]
  }.freeze

  def get_ads(account_id)
    get_data('ads', account_id, FIELDS[:ads])
  end

  def get_ad_sets(account_id)
    get_data('adsets', account_id, FIELDS[:adsets])
  end

  def get_ad_campaigns(account_id)
    get_data('campaigns', account_id, FIELDS[:campaigns], limit: 1000)
  end

  def get_ad_accounts(user_account_id)
    get_data('adaccounts', user_account_id, FIELDS[:adaccounts], limit: 1000)
  end

  def get_insights(_, account_id, fields, level, time_range)
    path_params = [BASE_URL, VERSION, account_id, 'insights']
    url = path_params.join('/')
    params = {
      access_token: @access_token,
      limit: 10_000,
      fields: fields.join(', '),
      time_range: time_range,
      time_increment: 1,
      level: level
    }
    send_request(url, params)
  end

  def get_account_insights(account_id)
    fields = FIELDS[:account_insights]
    time_range = get_time_range(7)
    get_insights('account', account_id, fields, 'account', time_range)
  end

  def get_campaign_insights(account_id)
    fields = FIELDS[:campaign_insights]
    time_range = get_time_range(7)
    get_insights('campaign', account_id, fields, 'campaign', time_range)
  end

  def get_adset_insights(account_id)
    fields = FIELDS[:adset_insights]
    time_range = get_time_range(7)
    get_insights('adset', account_id, fields, 'adset', time_range)
  end

  def get_ad_insights(account_id)
    fields = FIELDS[:ad_insights]
    time_range = get_time_range(7)
    get_insights('ad', account_id, fields, 'ad', time_range)
  end

  private

  def send_request(url, params)
    data = []
    continue = true

    loop do
      puts "Sending Request : GET : #{url}"
      puts params
      response = @req_handler.send_get_request(url, params)

      if response.code == '200'
        parsed_response = JSON.parse(response.body)
      else
        puts response.code
        puts response.body
        raise Exception.new('Failed to fetch data')
      end

      data += parsed_response['data']

      if parsed_response['paging'] && parsed_response['paging'].key?('next')
        after = parsed_response['paging']['cursors']['after']
        params['after'] = after
      else
        continue = false
      end

      break unless continue
    end

    puts "Fetched #{data.length} records"
    data
  end

  def get_time_range(days)
    today = Date.today
    since_date = (today - days - 3).strftime('%Y-%m-%d')
    until_date = (today - 3).strftime('%Y-%m-%d')
    { since: since_date, until: until_date }.to_json
  end

  def get_data(entity, account_id, fields, limit: 1000)
    path_params = [BASE_URL, VERSION, account_id, entity]
    url = path_params.join('/')
    params = {
      access_token: @access_token,
      limit: limit,
      fields: fields.join(', ')
    }
    send_request(url, params)
  end
end
