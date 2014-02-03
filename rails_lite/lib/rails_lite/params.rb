require 'uri'

class Params
  def initialize(req, route_params)
    @req = req
    parse_www_encoded_form(route_params)
  end

  def [](key)
  end

  def to_s
    top_hash = {}
    hash = {}
    top_key = ""
    @params.each do |params|
      key = ""
      value = ""
      params.each do |param|
        arr = parse_key(param)
        top_key = arr.first if arr.length == 2
        key = arr.last if arr.length == 2
        value = arr.first if arr.length == 1
      end
      hash[key] = value
    end
    top_hash[top_key] = hash
    top_hash.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    @params = URI::decode_www_form(www_encoded_form)
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
