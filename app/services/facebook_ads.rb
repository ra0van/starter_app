require_relative 'request_handler' 
require 'json'

access_token = 'EAAKDX99BZAz4BO75vjcOZCaPL2NheZCcQYXskZB1ag6hn7hD70DtvsQf99V2tXxXg8cJDMby8ZABxvK2QhfPAi0WA9drlZBEzZCZAdraKXTOjYI7tzyWzSn1Lt0PxXdUtADzaG7mfZAidIRZAdDIPS6fGpBxyEvZC99rxLfPBQDh3sc015VOENmCHAb7M0S39gzDu0x'
app_secret = '4fc406efd8e284f04bc46afa6fba6305'

base_url = "https://graph.facebook.com/"
user_account_id = "236247562146310" 
account_id = "act_202330961584003"
version   = "v18.0"

params = { 
    :access_token => access_token,
    :limit => 2200,
    :date_preset =>"yesterday", 
    :fields => "name, id, created_time, campaign_id, account_id, adset_id"
    }

reqHandler = HTTP::RequestHandler.new
response = reqHandler.send_get_request(base_url, version, account_id << "/ads", params)
parsed_response = JSON.parse(response)

parsed_response['data'].each do |child|
  puts child['name']
end

puts parsed_response['data'].size
