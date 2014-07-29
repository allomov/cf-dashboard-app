class LimitedQueue < Array
  attr_reader :index, :max_size
 
  def initialize(max_size = 2)
    @max_size = max_size
    super()
  end
 
  def <<(el)
    self.unshift(el)
    self.pop if self.length > @max_size
  end
 
  alias :push :<<
end