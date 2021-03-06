require 'mongo'

class MongodbManager
  include Mongo

  def self.config
    @config ||= Configuration.new('config/mongodb.yml', 
                                  prefix: 'mongodb',
                                  config_options: %w(host port database collection),
                                  default_options: {profile: false})
  end

  def self.client(force_connection = false)
    @client = nil if force_connection
    @client ||= MongoClient.new(config.host, config.port)
  end

  def self.database
    @database ||= client[config.database]
  end

  def self.collection
    @collection ||= database[config.collection]
  end

  def self.available?
    begin
      return true unless client(true).nil?
    rescue Mongo::ConnectionFailure
      false
  	end
  end

end