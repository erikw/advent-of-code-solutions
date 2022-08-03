#!/usr/bin/env ruby
# frozen_string_literal: true

min_presents = ARGF.readline.to_i

house_presents = Array.new(min_presents + 1, 0)
(1..min_presents / 10).each do |elf|
  (elf..([elf * 50, min_presents].min)).step(elf) do |house|
    house_presents[house] += elf * 11
  end
end

house = house_presents.each_with_index.select do |presents, _i|
  presents >= min_presents
end.first.last
puts house
