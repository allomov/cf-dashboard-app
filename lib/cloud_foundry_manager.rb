require 'settings'

class CloudFoundryManager

  def self.client
    @default_client ||= begin 
      CFoundry::Client.get(Settings.api).tap do |client| 
        client.login(username: Settings.admin.username, password: Settings.admin.password)
        client.base.rest_client.log = STDOUT if Settings.cf_profile
      end
    end
  end

  def self.space(name = Settings.space)
    self.organization.spaces.find {|space| space.name == name}
  end
  
  def self.organization(name = Settings.org)
    self.client.organizations.find {|org| org.name == name}
  end

  def self.application(name = Settings.app)
    self.space.apps.find {|app| app.name == name}
  end

end