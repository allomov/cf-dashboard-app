require 'configuration'

Config = Configuration.new(File.join(Rails.root, 'config', 'cf.yml'))

class CloudFoundryManager

  def self.client
    puts({username: Config.username, password: Config.password}.inspect)
    @default_client ||= begin 
      CFoundry::Client.get(Config.api).tap do |client| 
        client.login(username: Config.username, password: Config.password)
        client.base.rest_client.log = STDOUT if Config.profile
      end
    end
  end

  def self.space(name = Config.space)
    self.organization.spaces.find {|space| space.name == name}
  end
  
  def self.organization(name = Config.organization)
    self.client.organizations.find {|org| org.name == name}
  end

  def self.application(name = Config.application)
    self.space.apps.find {|app| app.name == name}
  end

end