#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

def component(edges, from)
  que = Thread::Queue.new([from])
  component = Set.new

  until que.empty?
    program = que.pop
    component << program
    edges[program].each { |to| que << to unless component.include?(to) }
  end
  component
end

def connected_components(edges)
  nodes = Set.new(edges.keys)
  components = []
  until nodes.empty?
    program = nodes.to_a.first
    nodes.delete(program)
    component = component(edges, program)
    components << component
    nodes -= component
  end
  components
end

pipes = Hash.new { |h, k| h[k] = Set.new }
ARGF.each_line do |line|
  parts = line.chomp.split('<->')
  from = parts[0].to_i
  parts[1].split(',').each do |to|
    pipes[from] << to.to_i
  end
end

puts connected_components(pipes).length
