class RedisCircularList
  attr_reader :client, :max_size, :name
  def initialize(redis_client, list_name, max_value)
    @client, @name, @max_size = redis_client, list_name, max_value
  end

  def size
    @client.llen(@name)
  end

  def <<(element)
    @client.lpush(@name, element)
    self.pop if self.size > @max_size
  end

  def pop
    @client.lpop(@name)
  end
end