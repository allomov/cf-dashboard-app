class CircularBuffer < Array
  attr_reader :index, :max_size
 
  def initialize(max_size = 2, default_value = nil, enum = nil)
    super(max_size, default_value)
    @index = 0
    @max_size = max_size
    enum.each { |e| self << e } if enum
  end
 
  def <<(el)
    super(el)
    pop
  end
 
  alias :push :<<
end