
require 'uri'
require 'net/http'
require 'geocoder'

class ResRobot
  API_KEY = '<key>'
  API_URL = 'https://api.resrobot.se/'
  API_FORMAT = 'json'
  API_VERSION = 'v2'

  attr_accessor :address_attribute

  def initialize(address_attribute)
    @address_attribute = address_attribute
  end

  def get_traffic_info(from, to)
    JSON.parse(Net::HTTP.get(build_query(from, to)))
  end

  private

  def build_query(from, to)
    query =
      <<-EOS.gsub(/^[\s\t]*|[\s\t]*\n/, '').tr('\\', '')
        #{API_URL}#{API_VERSION}/trip?key=#{API_KEY}
        &originCoordLat=#{geocode(from.method(@address_attribute).call, 'lat')}
        &originCoordLong=#{geocode(from.method(@address_attribute).call, 'lng')}
        &destCoordLat=#{geocode(to.method(@address_attribute).call, 'lat')}
        &destCoordLong=#{geocode(to.method(@address_attribute).call, 'lng')}
        &format=#{API_FORMAT}
      EOS
    URI(query)
  end

  def geocode(address, type)
    lat, lng = Geocoder.coordinates(Geocoder.address(address))
    type == 'lat' ? lat : lng
  end
end
