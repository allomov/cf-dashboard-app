require 'configuration'

config = Configuration.new('config/cf.yml')

class CloudFoundryManager

  def self.client
    @default_client ||= begin 
      CFoundry::Client.get(config.api).tap do |client| 
        client.login(username: config.username, password: config.password)
        client.base.rest_client.log = STDOUT if config.cf_profile
      end
    end
  end

  def self.space(name = config.space)
    self.organization.spaces.find {|space| space.name == name}
  end
  
  def self.organization(name = config.org)
    self.client.organizations.find {|org| org.name == name}
  end

  def self.application(name = config.app)
    self.space.apps.find {|app| app.name == name}
  end

end