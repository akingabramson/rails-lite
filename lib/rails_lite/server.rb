require 'webrick'
require_relative 'controller_base'

class MyController < ControllerBase
  def go
    if @request.path == "/redirect"
      redirect_to("http://www.google.com")
    elsif @request.path == "/show"
      render(:show)
    end
    @response
  end
end

server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }


server.mount_proc '/' do |request, response|

                          response.content_type = "text/text"
                          response.body = request.path
                          response = MyController.new(request, response, {}).go
                          response
                        end


server.start

