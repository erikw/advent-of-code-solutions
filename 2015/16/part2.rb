#!/usr/bin/env ruby
# frozen_string_literal: true

DETECTED = {
  'children:' => 3,
  'cats:' => 7,
  'samoyeds:' => 2,
  'pomeranians:' => 3,
  'akitas:' => 0,
  'vizslas:' => 0,
  'goldfish:' => 5,
  'trees:' => 3,
  'cars:' => 2,
  'perfumes:' => 1
}.freeze

nbr = ARGF.each_line.each_with_index.select do |l, nbr|
  l.split[2..].each_slice(2).to_h.all? do |k, v|
    case k
    when 'cats:', 'trees:'
      v.to_i > DETECTED[k]
    when 'pomeranians:', 'goldfish:'
      v.to_i < DETECTED[k]
    else
      v.to_i == DETECTED[k]
    end
  end
end.first.last + 1
puts nbr
