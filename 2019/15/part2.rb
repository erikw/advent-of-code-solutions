#!/usr/bin/env ruby
# frozen_string_literal: true
# Algorithm:
# * Find the map
# * Flood oxygen with a modifed BFS that goes ring by ring to count the depth/level (= minutes).

require_relative 'lib'

intcode = ARGF.readline.split(',').map(&:to_i)
computer = Computer.new
comp_thr = Thread.new { computer.execute(intcode) }

map = Hash.new(SYM_UNKNOWN) # Complex coord => symbol
map[POS_START] = SYM_OPEN

explore(map, computer, POS_START)
pos_oxysys = map.select { |_k, v| v == SYM_OXYSYS }.keys.first
num_open = map.count { |_k, v| v == SYM_OPEN }

que = Thread::Queue.new
que << pos_oxysys
minutes = 0
flooded = 0

until flooded == num_open
  layer_count = que.length
  layer_count.times do
    pos = que.pop
    DIR2DELTA.values.each do |delta|
      npos = pos + delta
      next unless map.keys.include?(npos) && map[npos] == SYM_OPEN

      map[npos] = SYM_OXYGEN
      flooded += 1
      que << npos
    end
  end
  # print_map(map)
  minutes += 1
end

puts minutes
