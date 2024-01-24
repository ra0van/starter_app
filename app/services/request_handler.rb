
require 'uri'
require 'net/http'
require 'openssl'

module HTTP
  class RequestHandler
    def send_get_request(base_url,version,relative_path,params)
      path = base_url << '/' << version << '/' << relative_path
      puts path
      url = URI(path)
      url.query = URI.encode_www_form(params)

      response = Net::HTTP.get_response(url)
      #puts response.read_body
      return response.read_body
    end
  end
end
