# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'

module HTTP
  # Class to make API request
  class RequestHandler
    def send_get_request(path, params)
      url = URI(path)
      url.query = URI.encode_www_form(params)

      Net::HTTP.get_response(url)
    end
  end
end
