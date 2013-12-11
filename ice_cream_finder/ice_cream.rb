require 'addressable/uri'
require 'rest-client'
require 'JSON'
require 'nokogiri'


class IceCreamFinder
  def initialize(options = {})
    default = {
      :address => "1016 market st, san francisco, ca",
      :radius => 1000
    }

    default.merge!(options)

    origin = self.get_current_location(default[:address])
    results = self.get_ice_cream_locations(origin, default[:radius])

    self.print_directions(results, origin)
  end

  def get_current_location(address)
    current_location_url = Addressable::URI.new(
        :scheme => "https",
        :host => "maps.googleapis.com",
        :path => "maps/api/geocode/json",
        :query_values => {
          :address => address,
          :sensor => false
        }
      ).to_s

    parsed_location = parse_json_results(current_location_url)

    # latitude and longitude hash of building
    lat_lng = parsed_location['results'][0]['geometry']['location']
    origin = "#{lat_lng['lat']},#{lat_lng['lng']}"
  end

  def parse_json_results(url)
    json_result = RestClient.get(url)
    parsed_result = JSON.parse(json_result)
  end

  def get_ice_cream_locations(origin, radius)
    nearby_search_url = Addressable::URI.new(
        :scheme => "https",
        :host => "maps.googleapis.com",
        :path => "maps/api/place/nearbysearch/json",
        :query_values => {
          :key => "AIzaSyDaSshVSSSdh77wnF-EXVY8lOjEV4fjlr0",
          :location => origin,
          :radius => 1000,
          :sensor => false,
          :keyword => "ice cream"
        }
      ).to_s

    parsed_nearby_search = parse_json_results(nearby_search_url)
    results = parsed_nearby_search['results']
  end

  def print_directions(results, origin)
    results.each do |result|
      puts "\n'#{result['name']}'"

      lat_lng = result['geometry']['location']
      destination = "#{lat_lng['lat']},#{lat_lng['lng']}"

      directions_search_url = Addressable::URI.new(
          :scheme => "https",
          :host => "maps.googleapis.com",
          :path => "maps/api/directions/json",
          :query_values => {
            :origin => origin,
            :destination => destination,
            :sensor => false,
          }
        ).to_s

      parsed_directions = parse_json_results(directions_search_url)

      legs = parsed_directions['routes'][0]['legs']
      self.print_steps(legs)
    end
  end

  def print_steps(legs)
    start_address = legs[0]['start_address']
    end_address = legs[0]['end_address']
    puts "  Starting Address: #{start_address}"
    puts "  Ending Address: #{end_address}"

    print "\nDirections \n"
    steps = legs[0]['steps']
    steps.each_with_index do |step, i|
      distance = step['distance']['text']
      instruction = Nokogiri::HTML(step['html_instructions']).text

      puts "  Step #{i+1}"
      puts "    In #{distance}"
      puts "    #{instruction}"
    end
  end
end

if $PROGRAM_NAME == __FILE__
  case ARGV.count
  when 0
    IceCreamFinder.new
  when 1
    IceCreamFinder.new(ARGV)
  end
end