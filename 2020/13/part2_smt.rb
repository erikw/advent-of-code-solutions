#!/usr/bin/env ruby
# frozen_string_literal: true

#
# Simply express the constraints and let Z3 solve it.
# Introduction: https://infosecadalid.com/2021/08/27/my-introduction-to-z3-and-solving-satisfiability-problems/
# This works for input1.0, input2.[1-4].
# However it's too slow for input2.5 and the actual problem input :-(.

require 'z3'

_time_arrival = ARGF.readline.to_i
busses = ARGF.readline.chomp.split(',').map(&:to_i).each_with_index.reject { |t, _i| t == 0 } # [bus_id, index]

vars = busses.length.times.map do |i|
  Z3.Int("bus_period_#{i}")
end

solver = Z3::Solver.new

solver.assert(vars[0] > 0)
# solver.assert(vars[0] * busses[0][0] >= 100_000_000_000_000)

(0...busses.length).each_cons(2) do |i, j|
  period_i = busses[i][0]
  period_j = busses[j][0]
  minute_diff = busses[j][1] - busses[i][1]

  solver.assert(minute_diff == (period_j * vars[j] - period_i * vars[i]))
end

# pp solver.assertions
solver.check

if solver.satisfiable?
  puts solver.model[vars[0]].to_i * busses[0][0]
else
  puts 'NOT SAT'
end
