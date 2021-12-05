class Point
  attr_reader :col, :row

  def initialize(col, row)
    @col = col
    @row = row
  end

  def ==(other)
    other.class == self.class && other.state == state
  end
  alias eql? ==

  def hash
    state.hash
  end

  def to_s
    "Point(#{col}, #{row})"
  end
  alias inspect to_s

  protected

  def state
    [@col, @row]
  end
end
