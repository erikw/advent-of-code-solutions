#!/usr/bin/env ruby
# frozen_string_literal: true

def apply_gravity(positions, velocities)
  (0...positions.length).to_a.combination(2).each do |a, b|
    if positions[a] < positions[b]
      velocities[a] += 1
      velocities[b] -= 1
    elsif positions[a] > positions[b]
      velocities[a] -= 1
      velocities[b] += 1
    end
  end
end

def apply_velocity(positions, velocities)
  positions.length.times do |i|
    positions[i] += velocities[i]
  end
end

def cycle_length(positions)
  velocities = Array.new(positions.length, 0)
  i = 0
  hash_init = [positions, velocities].hash
  loop do
    i += 1
    apply_gravity(positions, velocities)
    apply_velocity(positions, velocities)
    break if hash_init == [positions, velocities].hash
  end
  i
end

positions = ARGF.each_line.map { |l| l.scan(/-?\d+/).map(&:to_i) }

# The axes operate independently.
# Our answer is the LCM of the 3 different axis cyles.
cyclen_x = cycle_length(positions.transpose[0])
cyclen_y = cycle_length(positions.transpose[1])
cyclen_z = cycle_length(positions.transpose[2])
puts [cyclen_x, cyclen_y, cyclen_z].inject(&:lcm)
