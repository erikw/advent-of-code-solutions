#!/usr/bin/env ruby
# frozen_string_literal: true

in_rules, in_ticket_mine, in_ticket_nearby = ARGF.readlines.join.split("\n\n")

rules = []
in_rules.lines.each do |rule|
  rules << rule.scan(/\d+/).map(&:to_i).each_slice(2).to_a
end

ticket_mine = in_ticket_mine.lines.last.split(',').map(&:to_i)
tickets_nearby = in_ticket_nearby.lines.drop(1).map { |l| l.split(',').map(&:to_i) }

tser = 0
tickets_nearby.each do |ticket_nearby|
  ticket_nearby.each do |value|
    valid = rules.any? do |range1, range2|
      value.between?(*range1) || value.between?(*range2)
    end
    tser += value unless valid
  end
end

puts tser
