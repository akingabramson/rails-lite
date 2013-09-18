require 'erb'
require 'active_support/core_ext'

require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @request = req
    @response = res
    @params = Params.new(@request, route_params)
  end

  def session
    @session ||= Session.new(@request)
  end

  def already_rendered?
  end

  def redirect_to(url)
    if @response_built
      raise ArgumentError.new("Already rendered something!")
    else
      @response.status = 302
      @response['Location'] = url
      @response_built = true
      session.store_session(@response)
    end
  end

  def render_content(content, type)
    if @response_built
      raise ArgumentError.new("Already rendered something!")
    else
      @response.content_type = type
      @response.body = content
      @response_built = true
      session.store_session(@response)
    end
  end

  def render(action_name) #action_name is :show or :new, e.g.
    
    controller_name = self.class.name.underscore 
    #controller_name = e.g. UsersController, which is subclass of ControllerBase
    file = File.read("../../views/#{controller_name}/#{action_name}.html.erb")
    view = ERB.new(file).result(binding) #returns just html after you run result
    
    #file is the string with the ruby code, then run it
    #takes all the variables in the Controller (render variables
    #and instance variables)
        #could have called file in the ERB.new regardless, but it 
        #wouldn't have access to the instance 
        #variables in the controller until we call
        #binding on it

    render_content(view, "text/html")
  end

  def invoke_action(name)
    self.send(name)
    unless @response_built
      render(name)
    end
  end
end
