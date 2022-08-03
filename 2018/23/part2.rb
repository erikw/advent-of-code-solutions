#!/usr/bin/env ruby
# frozen_string_literal: true
# Hats off to https://www.reddit.com/r/adventofcode/comments/a8s17l/comment/ecdcbin/
require 'z3'

ORIGIN = [0, 0, 0]

def dist(pos1, pos2)
  pos1.zip(pos2).map { |a, b| (a - b).abs }.sum
end

def z3_abs(x)
  Z3.IfThenElse(x >= 0, x, -x)
end

def z3_dist(pos1, pos2)
  pos1.zip(pos2).map { |a, b| z3_abs(a - b) }.sum
end

nanobots = ARGF.each_line.map do |line|
  x, y, z, r = line.scan(/-?\d+/).map(&:to_i)
  [[x, y, z], r]
end

pos_sol = %w[x y z].each.map { |c| Z3.Int(c) }

cluster = Z3.Int('cluster')
cluster_expr = 0
nanobots.each do |pos, radius|
  cluster_expr += Z3.IfThenElse(z3_dist(pos_sol, pos) <= radius, 1, 0)
end

optimizer = Z3::Optimize.new
optimizer.assert(cluster == cluster_expr)
optimizer.maximize(cluster)
optimizer.minimize(z3_dist(ORIGIN, pos_sol))
optimizer.check

model = optimizer.model
pos_sol_int = pos_sol.map { |c| model[c].to_i }
# puts "Solved position: #{pos_sol_int.join(', ')}"
# puts "Number in range: #{model[cluster]}"
puts dist(ORIGIN, pos_sol_int)
