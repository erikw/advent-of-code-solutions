#!/usr/bin/env ruby
# NOTE this algorithm worked by luck. See part1.rb for correct BF solution.

require 'set'

def next_city(city, distance, visited)
  city_next = nil
  dist_next = nil
  distance[city].each do |neighbour, dist|
    next if visited.include? neighbour

    city_next = neighbour
    dist_next = dist
    break
  end

  [city_next, dist_next]
end

distance = Hash.new { |h, k| h[k] = [] }
smallest_dist = Float::INFINITY
city_head = nil
city_tail = nil
ARGF.each_line.map(&:split).each do |city1, _, city2, _, dist|
  dist = dist.to_i
  if dist < smallest_dist
    smallest_dist = dist
    city_head = city1
    city_tail = city2
  end
  distance[city1] << [city2, dist]
  distance[city2] << [city1, dist]
end

distance.each do |_, neighbours|
  neighbours.sort_by!(&:last)
end

visited = Set.new([city_head, city_tail])
tot_dist = smallest_dist
path = [city_head, city_tail]
loop do
  head_next, head_dist = next_city(city_head, distance, visited)
  tail_next, tail_dist = next_city(city_tail, distance, visited)
  if head_next.nil? && tail_next.nil?
    break
  elsif head_dist < tail_dist
    tot_dist += head_dist
    visited << head_next
    city_head = head_next
    path.prepend(city_head)
  else
    tot_dist += tail_dist
    visited << tail_next
    city_tail = tail_next
    path.append(city_tail)
  end
end

puts path.join(' -> ')
puts tot_dist
