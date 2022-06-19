#!/usr/bin/env ruby

require 'set'

dependencies = Hash.new { |h, k| h[k] = Set.new }
dependencies_rev = Hash.new { |h, k| h[k] = Set.new }
steps = Set.new
ARGF.each_line do |line|
  parts = line.split
  dependencies[parts[7]] << parts[1]
  dependencies_rev[parts[1]] << parts[7]
  steps << parts[1] << parts[7]
end

available = steps - Set.new(dependencies.keys)

order = []
until available.empty?
  order << available.to_a.sort.first
  available.delete(order.last)
  dependencies_rev[order.last].each do |step|
    available << step if dependencies[step].subset?(order.to_set)
  end
end

puts order.join
