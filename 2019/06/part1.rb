#!/usr/bin/env ruby

CENTER_OF_MASS = 'COM'

def steps_to(target, orbits, orbiter)
  steps = 0
  until orbiter == target
    orbiter = orbits[orbiter]
    steps += 1
  end
  steps
end

orbits = {} # orbiter -> orbitee
ARGF.each_line do |line|
  orbitee, orbiter = line.chomp.split(')')
  orbits[orbiter] = orbitee
end

puts orbits.keys.map { |orbiter| steps_to(CENTER_OF_MASS, orbits, orbiter) }.sum
