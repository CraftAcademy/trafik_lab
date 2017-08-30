

require 'ostruct'

#https://api.resrobot.se/v2/trip?key=<key>&originCoordLat=57.6905107&originCoordLong=11.9720847&destCoordLat=59.3467877&destCoordLong=18.0737329&format=json&numF=1
# Commands to run (Note that you have to pass in what attribute holds the address information.
# In this example it is 'full_address' )
from = OpenStruct.new(full_address: 'Holtermansgatan 1D, 41029 Göteborg')
to = OpenStruct.new(full_address: 'Båtsmansdalsgatan 7, 42432 Angered')
rutt = ResRobot.new(:full_address).get_traffic_info(from, to)
rutt['Trip'].first['LegList']['Leg'].each {|section| puts [section['Origin']['name'], section['Destination']['name']].join(' -> ') + ' ' + section['type']}

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
    query = "#{API_URL}#{API_VERSION}/trip?key=#{API_KEY}\
    &originCoordLat=#{geocode(from.method(@address_attribute).call, 'lat')}\
    &originCoordLong=#{geocode(from.method(@address_attribute).call, 'lng')}\
    &destCoordLat=#{geocode(to.method(@address_attribute).call, 'lat')}\
    &destCoordLong=#{geocode(to.method(@address_attribute).call, 'lng')}\
    &format=#{API_FORMAT}"
    URI(query)
  end

  def geocode(address, type)
    lat, lng = Geocoder.coordinates(Geocoder.address(address))
    type == 'lat' ? lat : lng
  end
end
