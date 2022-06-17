class Component
  attr_reader :port1, :port2

  def initialize(port1, port2)
    @port1 = port1
    @port2 = port2
  end

  def to_s
    "Component(#{@port1}, #{@port2})"
  end
  alias inspect to_s

  def hash
    state.hash
  end

  def ==(other)
    other.class == self.class && other.state == state
  end
  alias eql? ==

  protected

  def state
    [@port1, @port2]
  end
end

def bridge_strength(bridge)
  bridge.sum { |c| c.port1 + c.port2 }
end
