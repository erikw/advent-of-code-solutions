# frozen_string_literal: true

class Program
  attr_reader :name, :weight
  attr_accessor :subtowers

  def initialize(name, weight)
    @name = name
    @weight = weight
    @subtowers = []
  end

  def to_s
    "Program{#{@name}, #{@weight}, #{@subtowers.map(&:name)}}"
  end
  alias inspect to_s
end
