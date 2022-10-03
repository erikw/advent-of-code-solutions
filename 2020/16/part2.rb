#!/usr/bin/env ruby
# frozen_string_literal: true

in_rules, in_ticket_mine, in_ticket_nearby = ARGF.readlines.join.split("\n\n")

rules = []
departure_idxs = []
in_rules.lines.each.with_index do |rule, i|
  field = rule.split(':').first
  departure_idxs << i if field.start_with?('departure')
  rules << rule.scan(/\d+/).map(&:to_i).each_slice(2).to_a
end

ticket_mine = in_ticket_mine.lines.last.split(',').map(&:to_i)
tickets_nearby = in_ticket_nearby.lines.drop(1).map { |l| l.split(',').map(&:to_i) }

tickets_nearby.select! do |ticket_nearby|
  ticket_nearby.all? do |value|
    rules.any? do |range1, range2|
      value.between?(*range1) || value.between?(*range2)
    end
  end
end

# BF would be trying all permutations => 20!. Not reasonable
# Instead strike out possible assignements per field until all have only one.
# valid_assignments[f] are positions in rules that are valid (so far) for ticket field f.
valid_assignments = Array.new(rules.length) { (0...rules.length).to_a }

t = 0
while t < tickets_nearby.length && valid_assignments.any? { |assign| assign.length > 1 }
  tickets_nearby[t].each_with_index do |value, f|
    a = 0
    while a < valid_assignments[f].length
      range1, range2 = rules[valid_assignments[f][a]]
      if value.between?(*range1) || value.between?(*range2)
        a += 1
      else
        valid_assignments[f].delete_at(a)
      end
    end
  end
  t += 1
end

# Now continuously reduce assignments by removing the 1-1 mappings we found from all other field assignments.
while valid_assignments.any? { |assign| assign.length > 1 }
  valid_assignments.each_index do |i|
    next unless valid_assignments[i].length == 1

    valid_assignments.each_index do |j|
      next if j == i

      valid_assignments[j].delete(valid_assignments[i][0])
    end
  end
end

valid_assignments.flatten!(1)

departure_values = departure_idxs.map do |di|
  # Reverse mapping: rule nbr -> ticket field nbr
  ticket_pos = valid_assignments.index(di)
  ticket_mine[ticket_pos]
end.inject(&:*)

puts departure_values
