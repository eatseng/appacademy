require 'erb'
require 'active_support/core_ext'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @already_built_response = false
    @req = req
    @res = res
    @params = route_params
  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
    @already_built_response
  end

  def redirect_to(url)
    unless already_rendered?
      @already_built_response = true
      @res.status = 302
      @res.header["location"] = url
      #@session.store_session(@res)
    end
  end

  def render_content(content, type)
    unless already_rendered?
      @already_built_response = true
      @res.status =200
      @res['Content-Type'] = type
      @res.body = content
      #@session.store_session(@res)
    end
  end

  def render(template_name)
    @show = "showing this (instance variable in render)"

    filename = "../views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
    erb = ERB.new(File.read(filename))

    render_content(erb.result(binding), "text/html")
  end

  def invoke_action(name)
    self.send(name.to_sym)
    render(name) unless already_rendered?
  end
end
