require_relative 'request_handler' 
require 'json'

class Facebook

  @@access_token = 'EAAKDX99BZAz4BO75vjcOZCaPL2NheZCcQYXskZB1ag6hn7hD70DtvsQf99V2tXxXg8cJDMby8ZABxvK2QhfPAi0WA9drlZBEzZCZAdraKXTOjYI7tzyWzSn1Lt0PxXdUtADzaG7mfZAidIRZAdDIPS6fGpBxyEvZC99rxLfPBQDh3sc015VOENmCHAb7M0S39gzDu0x'
  @@app_secret = '4fc406efd8e284f04bc46afa6fba6305'

  @@base_url = "https://graph.facebook.com/"
  @@user_account_id = "236247562146310" 
  @@account_id = "act_202330961584003"
  @@version   = "v18.0"

  @@reqHandler = HTTP::RequestHandler.new

  def get_ads(account_id)
    url = @@base_url + '/' + @@version + '/' + @@account_id + "/" + "ads"
    params = { 
      :access_token => @@access_token,
      :limit => 2000,
      :date_preset =>"yesterday", 
      :fields => "name, id, created_time, campaign_id, account_id, adset_id" # TODO : Convert to enums & concat array to string
    }
    data = get(url, params)

    return data 
  end 

  def get_ad_sets(account_id)
    url = @@base_url + '/' + @@version + '/' + @@account_id + "/" + "adsets"
    params = { 
      :access_token => @@access_token,
      :limit => 1000,
      :date_preset =>"yesterday", 
      :fields => "name, id, created_time, campaign_id, account_id" # TODO : Convert to enums & concat array to string
    }
    data = get(url, params)

    return data 
  end 

  def get(url, params)  
    data = []
    continue = true 
    loop do
      puts 'Sending Request : GET : ' + url 
      response = @@reqHandler.send_get_request(url, params)

      if response.code == "200"
        parsed_response = JSON.parse response.body
      else 
        puts response.code
        puts response
        raise Exception.new "Failed to fetch data"
      end

      data = data + parsed_response['data']

      if parsed_response['paging'].has_key? 'next'
        after = parsed_response['paging']['cursors']['after']
        params['after'] = after
      else 
        continue = false
      end

      break if continue == false
    end
    puts "Fetched " + data.length.to_s + " records"
    return data
  end 

end 

fb = Facebook.new
fb.get_ad_sets("act_202330961584003")
