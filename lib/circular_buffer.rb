class CircularBuffer < Array
  attr_reader :index, :max_size
 
  def initialize(max_size = 2, enum = nil)
    super(max_size, 0)
    @index = 0
    @max_size = max_size
    enum.each { |e| self << e } if enum
  end
 
  def <<(el)
    @index = 0 if @index >= @max_size
    super[@index] = el
    @index = @index + 1
  end
 
  alias :push :<<
end