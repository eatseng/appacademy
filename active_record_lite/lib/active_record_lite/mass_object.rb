class MassObject
  # takes a list of attributes.
  # adds attributes to whitelist.
  def self.my_attr_accessible(*attributes)
    @attributes = []
    attributes.each do |variable|
      @attributes << variable
      self.my_attr_accessor(variable)
    end
  end

  # takes a list of attributes.
  # makes getters and setters
  def self.my_attr_accessor(*attributes)
    attributes.each do |variable|
      self.send(:define_method, "#{variable}") \
        {instance_variable_get("@#{variable}")}
      self.send(:define_method, "#{variable}=") \
        { |x| instance_variable_set("@#{variable}", x)}
    end
  end


  # returns list of attributes that have been whitelisted.
  def self.attributes
    @attributes
  end

  # takes an array of hashes.
  # returns array of objects.
  def self.parse_all(results)
    objects = []
    results.each { |option| objects << self.new(option) }
    objects
  end

  # takes a hash of { attr_name => attr_val }.
  # checks the whitelist.
  # if the key (attr_name) is in the whitelist, the value (attr_val)
  # is assigned to the instance variable.
  def initialize(params = {})
    params.each do |key, value|
      key = key.to_sym if key.class == String
      raise StandardError.new "mass assignment to unregistered attribute #{key}"\
        unless self.class.attributes.include?(key)
      self.send("#{key}=", value)
    end
  end
end
