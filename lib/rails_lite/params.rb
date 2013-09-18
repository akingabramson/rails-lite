require 'uri'

class Params
  def initialize(req, route_params)
    @request = req
    @params = {} #could be an empty hash
    parse_www_encoded_form(@request.query_string) if @request.query_string
    parse_www_encoded_form(@request.body) if @request.body
    @params.merge!(route_params.dup) if route_params != {}

  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    keys_vals = URI::decode_www_form(www_encoded_form)

    parsed_keys_with_values = []

    keys_vals.each do |key_val|
      parsed_keys_with_values << [parse_key(key_val[0]), key_val[1]]
      #parsed_keys_with_values = array with each individual 
      #[["cats", "cutie", "color"], "tortie"], e.g.
    end

    hashed_params = {}
    pointer = {}

    parsed_keys_with_values.each do |keys, value|
                                    #[["cat", "name"], "breakfast"]
      pointer = hashed_params


      while !keys.empty?
        key = keys.shift
        pointer[key] ||= {} # Crucial to ||=, so that if the nested hash exists we dont overwrite it.
                            # goes down a level
        if keys.empty?
          pointer[key] = value
        else
          pointer = pointer[key]
        end
      end
    end

    @params.merge!(hashed_params)

  end

  def parse_key(key)
    if key =~ /\[/
      keys_array = key.match(/(?<head>\w+)\[(?<second>\w+)\](?<rest>.*)/)
      [keys_array["head"]] + parse_key(keys_array["second"]+keys_array["rest"])
    else
      [key]
    end
  end

end
