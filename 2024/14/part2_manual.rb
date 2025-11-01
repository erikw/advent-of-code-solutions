#!/usr/bin/env ruby
# frozen_string_literal: true

SIMULATION_SECS = 100

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

print_robots(robots)

t = 0
seen = Set.new
loop do
  key = robots.hash
  break if seen.include?(key)

  seen << key

  robots_next = Hash.new { |h, k| h[k] = [] }
  robots.each_pair do |(x, y), velocities|
    velocities.each do |vx, vy|
      pos_next = [(x + vx) % WIDTH, (y + vy) % HEIGHT]
      robots_next[pos_next] << [vx, vy]
    end
  end
  robots = robots_next
  t += 1
  puts "t=#{t}"
  print_robots(robots)
  sleep(0.1)
end

# Now observe the security tape on fast-forward.
# Alternatively grep the output for a likely pattern of "11111111"
