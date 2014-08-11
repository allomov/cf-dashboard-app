require 'mongo'

class MongodbManager
  include Mongo

  def self.client
    @client ||= MongoClient.new(ENV['MONGODB_HOST'], ENV['MONGODB_PORT'])
  end

  def self.database
    @database ||= client[ENV['MONGODB_DATABASE']]
  end

  def self.collection
    @collection ||= database[ENV['MONGODB_COLLECTION']]
  end

  def self.available?
    begin
      return true unless client.nil?
    rescue Mongo::ConnectionFailure
      false
  	end
  end

end