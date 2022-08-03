#!/usr/bin/env ruby
# frozen_string_literal: true

x1, x2, y1, y2 = ARGF.readline.chomp.delete_prefix!('target area: ').gsub!(/.=/, '').split(', ').map do |part|
  part.split('..').map(&:to_i)
end.flatten

def step_simulate(vx, vy, x1, x2, y1, y2, pos_x = 0, pos_y = 0)
  return 0 if pos_x > x2 || pos_y < y1
  return 1 if pos_x >= x1 && pos_y <= y2

  step_simulate(vx > 0 ? vx - 1 : 0, vy - 1, x1, x2, y1, y2, pos_x + vx, pos_y + vy)
end

hits = 0
(y1...-y1).each do |vy|
  (1...(x2 + 1)).each do |vx|
    hits += step_simulate(vx, vy, x1, x2, y1, y2)
  end
end
puts hits
