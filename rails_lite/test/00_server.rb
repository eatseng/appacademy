require 'active_support/core_ext'
require 'webrick'
require '../lib/rails_lite.rb'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html
server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

class MyController < ControllerBase
  def go
    #redirect_to("http://www.google.com")
    #render_content("hello world!", "text/html")

    # after you have template rendering, uncomment:
    #render :show

    # after you have sessions going, uncomment:
    the_session = self.session()
    the_session["count"] ||= 0
    the_session["count"] += 1
    render :counting_show
  end
end

server.mount_proc '/' do |req, res|
  MyController.new(req, res).go
end

server.start
