#!/usr/bin/env ruby

fishes = gets.split(',').map(&:to_i)

80.times do
  fishlings = []
  fishes.map! do |fish|
    if (fish - 1) == -1
      fish = 7
      fishlings << 8
    end
    fish - 1
  end
  fishes.concat(fishlings)
end
puts fishes.length
