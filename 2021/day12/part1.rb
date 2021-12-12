#!/usr/bin/env ruby

require 'set'

require_relative 'node'

def find_paths(nodes, node_cur, paths_all, path_cur)
  path_cur << node_cur
  if node_cur == nodes['end']
    paths_all << path_cur.dup
  else
    node_cur.neighbours.each do |neighbour|
      unless neighbour.name == 'start' || neighbour.is_small? && path_cur.include?(neighbour)
        find_paths(nodes, neighbour, paths_all, path_cur)
      end
    end
  end
  path_cur.pop
end

def find_all_paths(nodes)
  paths_all = []
  path_cur = []
  start = nodes['start']
  find_paths(nodes, start, paths_all, path_cur)
  paths_all
end

nodes = {} # str -> Node
ARGF.each_line.map { |line| line.chomp.split('-') }.each do |left, right|
  node_left = nodes.fetch(left, Node.new(left))
  node_right = nodes.fetch(right, Node.new(right))
  nodes[left] = node_left
  nodes[right] = node_right

  node_left.edge_to(node_right)
  node_right.edge_to(node_left)
end

all_paths = find_all_paths(nodes)
puts all_paths.length
