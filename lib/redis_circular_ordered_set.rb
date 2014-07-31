class RedisCircularOrderedSet

  attr_reader :client, :max_duration, :name

  def initialize(redis_client, list_name, max_duration)
    @client, @name, @max_duration = redis_client, list_name, max_duration
  end

  def add(time, value)
  	float_time = time.to_i
  	@client.zadd(@name, float_time, value.to_s)
    min_time = float_time - @max_duration
  	@client.zremrangebyscore(@name, "0", "(#{min_time.to_i}")
  end

  def list
  	self.map { |value_string, float_time| {time: Time.at(float_time), value: value_string.to_f} }
  end

  def map(&block)
  	@client.zrevrange(@name, 0, -1, with_scores: true).map(&block)
  end
end