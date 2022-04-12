#!/usr/bin/env ruby

min_presents = ARGF.readline.to_i

# n = 0
# packages = 0
# until packages >= min_presents
#  n += 1
#  packages = (1..n).sum do |i|
#    n % i == 0 ? i * 10 : 0
#  end
# end
# puts n

house_presents = Array.new(min_presents / 10 + 1, 0)
(1..min_presents).each do |elf|
  (elf..min_presents / 10).step(elf) do |house|
    house_presents[house] += elf * 10
  end
end

house = house_presents.each_with_index.select do |presents, _i|
  presents >= min_presents
end.first.last
puts house
