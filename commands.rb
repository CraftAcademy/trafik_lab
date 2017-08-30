require 'ostruct'

#https://api.resrobot.se/v2/trip?key=<key>&originCoordLat=57.6905107&originCoordLong=11.9720847&destCoordLat=59.3467877&destCoordLong=18.0737329&format=json&numF=1
# Commands to run (Note that you have to pass in what attribute holds the address information.
# In this example it is 'full_address' )
from = OpenStruct.new(full_address: 'Holtermansgatan 1D, 41029 Göteborg')
to = OpenStruct.new(full_address: 'Båtsmansdalsgatan 7, 42432 Angered')
rutt = ResRobot.new(:full_address).get_traffic_info(from, to)

# Now do something meaningful with the result....
rutt['Trip'].first['LegList']['Leg'].each {|section| puts [section['Origin']['name'], section['Destination']['name']].join(' -> ') + ' ' + section['type']}
