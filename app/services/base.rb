require 'rest-client'

class Base < Hashie::Mash
  def self.get(path, objectify:, query: {})
    query = pack(query,objectify: objectify)
    uri = "#{FacebookAds.base_uri}#{path}?" + build_nested_query(query)

    response = begin
                 Restclient.get(uri, FacebookAds.REQUEST_HEADERS)
    rescue RestClient::Exception => e 
      exception(:get, path, e)
    end
  end
end
