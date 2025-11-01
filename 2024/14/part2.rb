#!/usr/bin/env ruby
# frozen_string_literal: true

WIDTH = 101
HEIGHT = 103

TREE_HEURISTIC_LEN = 7

Robot = Struct.new(:x, :y, :vx, :vy)

def tree_detected?(robots)
  counts = Array.new(HEIGHT) { Array.new(WIDTH, 0) }
  robots.each { |r| counts[r.y][r.x] += 1 }

  counts.any? do |row|
    consec = 0
    row.any? do |cell|
      consec = cell == 1 ? consec + 1 : 0
      consec >= TREE_HEURISTIC_LEN
    end
  end
end

robots = ARGF.each_line.map do |line|
  x, y, vx, vy = line.scan(/-?\d+/).map(&:to_i)
  Robot.new(x, y, vx, vy)
end

t = 0
until tree_detected?(robots)
  robots.each do |robot|
    robot.x = (robot.x + robot.vx) % WIDTH
    robot.y = (robot.y + robot.vy) % HEIGHT
  end
  t += 1
end

puts t
