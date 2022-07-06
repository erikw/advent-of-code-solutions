#!/usr/bin/env ruby

require_relative 'lib'

groups = parse_input.sort_by(&:name)
groups_orig = Marshal.load(Marshal.dump(groups))

units = nil
boost = 0
winner = nil
until winner == :immune
  groups.each_with_index do |group, i|
    group.units = groups_orig[i].units
    group.damage = groups_orig[i].damage + boost if group.army == :immune
  end

  units, winner = battle(groups)
  boost += 1
end
puts units
