require 'json'
require 'webrick'

class Session
  def initialize(request)
    cookie = request.cookies.find do |cookie|
              cookie.name == "_rails_lite_app"
              end
    if cookie.nil?
      @data = {}
    else
      @data = JSON.parse(cookie.value)
    end

  end

  def [](key)
    @data[key]
  end

  def []=(key, val)
    @data[key] = val
  end

  def store_session(response)
    response.cookies << WEBrick::Cookie.new('_rails_lite_app', @data.to_json)
  end
end
