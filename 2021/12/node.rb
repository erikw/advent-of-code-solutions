class Node
  attr_reader :name, :neighbours

  def initialize(name)
    @name = name
    @neighbours = Set.new
  end

  def edge_to(other)
    @neighbours << other
  end

  def is_small?
    @name == @name.downcase
  end

  def to_s
    "Node(name=#{@name}, neighbours={#{@neighbours.map(&:name).sort.join(', ')}})"
  end
  alias inspect to_s

  def ==(other)
    other.class == self.class && other.state == state
  end
  alias eql? ==

  def hash
    state.hash
  end

  protected

  def state
    [@name, @neighbours]
  end
end
