#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

MY_BAG = 'shiny gold'

def component(dag, start)
  discovered = Set[start]
  queue = Thread::Queue.new([start])
  until queue.empty?
    node = queue.pop
    dag[node].each do |child|
      queue << child unless discovered.include?(child)
      discovered << child
    end
  end
  discovered
end

# contain = Hash.new { |h, k| h[k] = [] }
container = Hash.new { |h, k| h[k] = [] }
ARGF.each_line do |line|
  container_bag, bags_contained = line.chomp.split(' bags contain ')
  next if bags_contained == 'no other bags.'

  bags_contained.split(', ') do |bag_contained|
    match = bag_contained.match(/\d+ (\w+ \w+) bags?\.?/)
    # contain[container_bag] << match[1]
    container[match[1]] << container_bag
  end
end

nbr_container = component(container, MY_BAG).size - 1
puts nbr_container
