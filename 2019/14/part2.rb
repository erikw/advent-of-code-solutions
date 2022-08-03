#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

ORES = 1_000_000_000_000

inv_reactions = inv_reactions_from_input

# The solution is simply not (ORES / fuel_cost(inv_reactions, 1).to_f).floor
# because there might be reactions that pays off more in the long run when we need
# more than 1 fuel.
# Instead: binary search the solution!

lower = (ORES / fuel_cost(inv_reactions, 1).to_f).floor.to_f
upper = lower * 2 # Heuristic

mid = nil
cost = nil
while lower <= upper
  mid = ((upper - lower) / 2.0).floor + lower
  cost = fuel_cost(inv_reactions, mid)
  if cost < ORES
    lower = mid + 1
  elsif cost > ORES
    upper = mid - 1
  else
    break
  end
end

mid -= 1 if cost > ORES
puts mid.to_i
