#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

MY_BAG = 'shiny gold'

def sub_bags(contain, current_bag)
  bags = 0
  contain[current_bag].each do |amount, bag|
    bags += amount
    bags += amount * sub_bags(contain, bag)
  end
  bags
end

contain = Hash.new { |h, k| h[k] = [] }
ARGF.each_line do |line|
  container_bag, bags_contained = line.chomp.split(' bags contain ')
  next if bags_contained == 'no other bags.'

  bags_contained.split(', ') do |bag_contained|
    m = bag_contained.match(/(?<nbr>\d+) (?<bag>\w+ \w+) bags?\.?/)
    contain[container_bag] << [m['nbr'].to_i, m['bag']]
  end
end

puts sub_bags(contain, MY_BAG)
