#!/usr/bin/env ruby
# frozen_string_literal: true

SIMULATION_SECS = 100

# WIDTH = 11
# HEIGHT = 7
WIDTH = 101
HEIGHT = 103

def print_robots(robots)
  HEIGHT.times do |y|
    WIDTH.times do |x|
      pos = [x, y]
      print robots.key?(pos) ? robots[pos].size : '.'
    end
    puts
  end
end

robots = Hash.new { |h, k| h[k] = [] }
ARGF.each_line do |line|
  x, y, vx, vy = line.scan(/-?\d+/).map(&:to_i)
  robots[[x, y]] << [vx, vy]
end

SIMULATION_SECS.times do |t|
  robots_next = Hash.new { |h, k| h[k] = [] }
  robots.each_pair do |(x, y), velocities|
    velocities.each do |vx, vy|
      pos_next = [(x + vx) % WIDTH, (y + vy) % HEIGHT]
      robots_next[pos_next] << [vx, vy]
    end
  end
  robots = robots_next
end

quadrant_counts = [[0, 0], [0, 0]]
mid_y = HEIGHT / 2
mid_x = WIDTH / 2
robots.each_pair do |(x, y), velocities|
  next if x == mid_x || y == mid_y

  qx = x / (mid_x + 1)
  qy = y / (mid_y + 1)
  quadrant_counts[qy][qx] += velocities.size
end

safety_factor = quadrant_counts.flatten.inject(&:*)
puts safety_factor
