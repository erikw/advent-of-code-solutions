#!/usr/bin/env ruby
# frozen_string_literal: true

# Algorithm:
# * Instead of storing a grid like in part1, store sparse matrix of current bugs as a array of [layer, x, y]
#   * Specifically it becomes more efficient to store as Hash[layer] -> Set[[x,y]]
# * For each tick:
#   * create a copy of current state
#   * check each stored bug, if they will die from not having exactly 1 neighbour (in new state version, using logic to go to inner/outer layer on borders)
#   * check each stored bug, in a circle around it the empty spaces, if they have one additional bug neighbour => space becomes bug (in new state version, also with inner/outer layer logic)

require 'set'

SYM_BUG = '#'
SYM_EMPTY = '.'
SYM_MIDDLE = '?'

DIM = 5
NEIGHBOUR_DELTAS = {
  north: [-1, 0],
  west: [0, -1],
  east: [0, 1],
  south: [1, 0]
}

# MINUTES = 10
MINUTES = 200

def neighbour_coordinates(layer, row, col)
  neighbours = Hash.new { |h, k| h[k] = Set.new } # layer -> Set[x, y]
  NEIGHBOUR_DELTAS.values.each do |dr, dc|
    rown = row + dr
    coln = col + dc
    layern = layer
    middle = (DIM / 2)
    if [rown, coln] == [middle, middle] # To inner layer
      layern += 1
      case [dr, dc]
      when NEIGHBOUR_DELTAS[:north] # cell 18 moving up
        (0...DIM).each do |coln|
          neighbours[layern] << [DIM - 1, coln]
        end
      when NEIGHBOUR_DELTAS[:east] # cell 12 moving right
        (0...DIM).each do |rown|
          neighbours[layern] << [rown, 0]
        end
      when NEIGHBOUR_DELTAS[:south] # cell 8 moving down
        (0...DIM).each do |coln|
          neighbours[layern] << [0, coln]
        end
      when NEIGHBOUR_DELTAS[:west] # cell 14 moving left
        (0...DIM).each do |rown|
          neighbours[layern] << [rown, DIM - 1]
        end
      end
    else
      # Handle outer layer
      if rown == -1
        layern -= 1
        rown = 1
        coln = 2
      elsif rown == DIM
        layern -= 1
        rown = 3
        coln = 2
      elsif coln == -1
        layern -= 1
        rown = 2
        coln = 1
      elsif coln == DIM
        layern -= 1
        rown = 2
        coln = 3
      end
      neighbours[layern] << [rown, coln]
    end
  end
  neighbours
end

def neighbours(bugs, layer, row, col)
  neighbours = [] # [layer, row, col]
  neighbour_coordinates(layer, row, col).each do |layern, neighbour_coords|
    neighbour_coords.count do |neighbour|
      neighbours << [layern, *neighbour] if bugs[layern].include?(neighbour)
    end
  end
  neighbours
end

def tick(bugs)
  # Can't Marshal dump hash with default proc.
  defproc = bugs.default_proc
  bugs.default = nil
  bugs_prev = Marshal.load(Marshal.dump(bugs))
  bugs.default_proc = defproc
  bugs_prev.default_proc = defproc

  bugs_prev.keys.each do |layer|
    bugs_prev[layer].each do |row, col|
      # Condition for bugs
      bugs[layer].delete([row, col]) unless neighbours(bugs_prev, layer, row, col).length == 1

      # Condition for empty
      neighbour_coordinates(layer, row, col).sum do |layern, neighbour_coords|
        neighbour_coords.count do |neighbour|
          next if bugs_prev[layern].include?(neighbour) # Not empty tile

          emptys_neighbours = neighbours(bugs_prev, layern, *neighbour)
          bugs[layern] << neighbour if [1, 2].include?(emptys_neighbours.length)
        end
      end
    end
    bugs.delete(layer) if bugs[layer].empty?
  end
end

def print_tiles(bugs)
  middle = (DIM / 2)
  bugs.keys.sort.each do |layer|
    next if bugs[layer].empty? # Weird bug

    puts "Depth #{layer}:"
    DIM.times do |row|
      DIM.times do |col|
        if [row, col] == [middle, middle]
          print SYM_MIDDLE
        else
          print bugs[layer].include?([row, col]) ? SYM_BUG : SYM_EMPTY
        end
      end
      puts
    end
  end
end

bugs = Hash.new { |h, k| h[k] = Set.new } # layer -> Set[x, y]
ARGF.each_line.with_index do |line, row|
  line.chomp.each_char.with_index do |char, col|
    bugs[0] << [row, col] if char == SYM_BUG
  end
end

MINUTES.times do |_i|
  tick(bugs)
  # puts "===== After minute #{i + 1} ====="
  # print_tiles(bugs, i)
end
puts bugs.values.map(&:to_a).flatten(1).size
