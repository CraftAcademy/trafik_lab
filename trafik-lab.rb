


#https://api.resrobot.se/v2/trip?key=<key>&originCoordLat=57.6905107&originCoordLong=11.9720847&destCoordLat=59.3467877&destCoordLong=18.0737329&format=json&numF=1

from = OpenStruct.new(full_address: 'Holtermansgatan 1D, 41029 Göteborg')
to = OpenStruct.new(full_address: 'Båtsmansdalsgatan 7, 42432 Angered')
rutt = ResRobot.new.get_traffic_info(from, to)
rutt['Trip'].first['LegList']['Leg'].each {|section| puts [section['Origin']['name'], section['Destination']['name']].join(' -> ') + ' ' + section['type']}

require 'uri'

class ResRobot

  def get_traffic_info(from, to)
    route = JSON.parse(open(build_query(from, to)).read)
  end

  private

  def build_query(from, to)
    api_key = '<key>'
    api_url = 'https://api.resrobot.se/'
    api_format = 'json'
    api_version = 'v2'
    "#{api_url}#{api_version}/trip?key=#{api_key}&originCoordLat=#{geocode(from.full_address, 'lat')}&originCoordLong=#{geocode(from.full_address, 'lng')}&destCoordLat=#{geocode(to.full_address, 'lat')}&destCoordLong=#{geocode(to.full_address, 'lng')}&format=#{api_format}"
  end

  def geocode(address, type)
    lat, lng = Geocoder.coordinates(Geocoder.address(address))
    if type == 'lat'
      lat
    else
      lng
    end
  end

end
