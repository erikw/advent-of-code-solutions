#!/usr/bin/env ruby

require 'set'

# WORKERS = 2
# STEP_TIME = 0
STEP_TIME = 60
WORKERS = 5

dependencies = Hash.new { |h, k| h[k] = Set.new }
dependencies_rev = Hash.new { |h, k| h[k] = Set.new }
steps = Set.new
ARGF.each_line do |line|
  parts = line.split
  dependencies[parts[7]] << parts[1]
  dependencies_rev[parts[1]] << parts[7]
  steps << parts[1] << parts[7]
end

available = steps - Set.new(dependencies.keys)

order = []
workers = Array.new(WORKERS)
second = -1
until available.empty? && workers.all? { |w| w.nil? }
  second += 1

  (0...WORKERS).reject { |w| workers[w].nil? }.each do |worker|
    workers[worker][1] -= 1
    next unless workers[worker][1].zero?

    order << workers[worker][0]
    workers[worker] = nil
    dependencies_rev[order.last].each do |step|
      available << step if dependencies[step].subset?(order.to_set)
    end
  end

  free_workers = workers.each_with_index.select { |w, _i| w.nil? }.map(&:last)
  while available.length > 0 && free_workers.length > 0
    free_worker = free_workers.pop
    next_step = available.to_a.sort.first
    available.delete(next_step)
    workers[free_worker] = [next_step, STEP_TIME + next_step.ord - 'A'.ord + 1]
  end
end

puts second
