require 'addressable/uri'
require 'rest-client'

class User

  def generate_url(path)
    url = Addressable::URI.new(
      scheme: 'http',
      host: 'localhost',
      port: 3000,
      path: "/users#{path}",
    ).to_s

  end

  def get
    url = generate_url("")
    puts RestClient.get(url)
  end

  def create
    url = generate_url("")
    puts RestClient.post(url, {:user => {:name => "Jeff", :email => "jeff@app.io"}})
  end

  def update
    url = generate_url("/1")
    puts RestClient.put(url, {:user => {:name => "Jeffrey", :email => "jeff@app.io"}})
  end

  def destroy
    url = generate_url("/1")
    puts RestClient.delete(url)
  end
end


class Contact

  def generate_url(path)
    url = Addressable::URI.new(
      scheme: 'http',
      host: 'localhost',
      port: 3000,
      path: "/contacts#{path}",
    ).to_s
  end

  def get
    url = generate_url("")
    puts RestClient.get(url)
  end

  def create
    url = generate_url("")
    puts RestClient.post(url, {
      :contacts => {:name => "Jeff", :email => "jeff@app.io", :user_id => 2}})
  end

  def update
    url = generate_url("/6")
    puts RestClient.put(url, {
      :contacts => {:name => "Ryan", :email => "ryan@app.io", :user_id => 2}})
  end

  def destroy
    url = generate_url("/7")
    puts RestClient.delete(url)
  end

end

class ContactShare

  def generate_url(path)
    url = Addressable::URI.new(
      scheme: 'http',
      host: 'localhost',
      port: 3000,
      path: "/contact_shares#{path}",
    ).to_s
  end

  def get
    url = generate_url("")
    puts RestClient.get(url)
  end

  def create
    url = generate_url("")
    puts RestClient.post(url, {
      :contact_shares => { :user_id => 2, :contact_id => 2}})
  end

  def destroy
    url = generate_url("/1")
    puts RestClient.delete(url)
  end

end




