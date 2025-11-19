#!/usr/bin/env ruby
# frozen_string_literal: true

CLIQUE_SIZE = 3
COMPUTER_START_LETTER = 't'

neighbors = Hash.new { |h, k| h[k] = [] } # node -> [nodes]
ARGF.each_line(chomp: true) do |line|
  n1, n2 = line.split('-')
  neighbors[n1] << n2
  neighbors[n2] << n1
end

cliques = Set.new

neighbors.each_pair do |node, node_neighbors|
  node_neighbors.combination(2) do |node2, node3|
    nodes = [node, node2, node3].sort
    cliques << nodes if neighbors[node2].include?(node3) && nodes.map(&:chr).any? { |c| c == COMPUTER_START_LETTER }
  end
end

puts cliques.size
