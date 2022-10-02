#!/usr/bin/env ruby
# frozen_string_literal: true

time_arrival = ARGF.readline.to_i
bus_ids = ARGF.readline.chomp.split(',').reject { |c| c == 'x' }.map(&:to_i)

best_bus, time_departure = bus_ids.map do |bus_id|
  x = (time_arrival / bus_id.to_f).ceil
  [bus_id, bus_id * x]
end.min_by(&:last)

time_wait = time_departure - time_arrival
puts best_bus * time_wait
