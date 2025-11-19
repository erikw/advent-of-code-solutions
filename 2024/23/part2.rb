#!/usr/bin/env ruby
# frozen_string_literal: true

# Ref: https://en.wikipedia.org/wiki/Bron–Kerbosch_algorithm
def bron_kerbosch_max_clique(neighbors, p_candidates, r_clique = Set.new, x_excluded = Set.new)
  return [r_clique.to_a] if p_candidates.empty? && x_excluded.empty?

  cliques = []
  pivot = (p_candidates | x_excluded).max_by { |n| neighbors[n].size }

  (p_candidates - neighbors[pivot]).each do |node|
    sub_cliques = bron_kerbosch_max_clique(neighbors, p_candidates & neighbors[node], r_clique | [node],
                                           x_excluded & neighbors[node])
    cliques.concat(sub_cliques)
    p_candidates.delete(node)
    x_excluded.add(node)
  end

  cliques
end

neighbors = Hash.new { |h, k| h[k] = Set.new } # node -> [nodes]
ARGF.each_line(chomp: true) do |line|
  n1, n2 = line.split('-')
  neighbors[n1] << n2
  neighbors[n2] << n1
end

maximal_cliques = bron_kerbosch_max_clique(neighbors, neighbors.keys.to_set)
maximum_clique = maximal_cliques.max_by(&:size)

password = maximum_clique.sort.join(',')
puts password
