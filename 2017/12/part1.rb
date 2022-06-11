#!/usr/bin/env ruby

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

pipes = Hash.new { |h, k| h[k] = Set.new }
ARGF.each_line do |line|
  parts = line.chomp.split('<->')
  from = parts[0].to_i
  parts[1].split(',').each do |to|
    pipes[from] << to.to_i
  end
end

puts component(pipes, 0).length
