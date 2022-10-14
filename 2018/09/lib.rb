# frozen_string_literal: true

class Marble
  attr_accessor :next, :prev
  attr_reader :value

  def initialize(value)
    @value = value
    @next = nil
    @prev = nil
  end

  def to_s
    nxt = @next.nil? ? 'nil' : @next.value
    prv = @prev.nil? ? 'nil' : @prev.value
    "Node(#{value}, prev=#{prv}, next=#{nxt})"
  end
  alias inspect to_s
end

def marble_game(players, marbles)
  scores = Array.new(players, 0)
  cur_player = 0
  cur_marble = Marble.new(0)
  cur_marble.next = cur_marble
  cur_marble.prev = cur_marble

  (1..marbles).each do |value|
    marble = Marble.new(value)

    if value % 23 == 0
      6.times { cur_marble = cur_marble.prev }
      scores[cur_player] += marble.value + cur_marble.prev.value

      cur_marble.prev.prev.next = cur_marble
      cur_marble.prev = cur_marble.prev.prev
    else
      marble.prev = cur_marble.next
      marble.next = cur_marble.next.next

      cur_marble.next.next.prev = marble
      cur_marble.next.next = marble

      cur_marble = marble
    end

    cur_player = (cur_player + 1) % players
  end
  scores
end
