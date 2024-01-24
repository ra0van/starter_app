
require 'uri'
require 'net/http'
require 'openssl'

module HTTP
  class RequestHandler
    def send_get_request(path,params)
      url = URI(path)
      url.query = URI.encode_www_form(params)

      response = Net::HTTP.get_response(url)
      #puts response
      return response
    end
  end
end
