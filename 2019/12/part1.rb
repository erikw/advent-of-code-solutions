#!/usr/bin/env ruby

# STEPS = 10
# STEPS = 100
STEPS = 1000

def apply_gravity(positions, velocities)
  (0...positions.length).to_a.combination(2).each do |a, b|
    (0...3).each do |i|
      if positions[a][i] < positions[b][i]
        velocities[a][i] += 1
        velocities[b][i] -= 1
      elsif positions[a][i] > positions[b][i]
        velocities[a][i] -= 1
        velocities[b][i] += 1
      end
    end
  end
end

def apply_velocity(positions, velocities)
  positions.length.times do |i|
    positions[i] = positions[i].zip(velocities[i]).map { |a, b| a + b }
  end
end

def potential_energy(position)
  position.map(&:abs).sum
end
alias kinetic_energy potential_energy

def total_energy(positions, velocities)
  positions.zip(velocities).sum do |position, velocity|
    potential_energy(position) * kinetic_energy(velocity)
  end
end

positions = ARGF.each_line.map { |l| l.scan(/-?\d+/).map(&:to_i) }
velocities = Array.new(positions.length) { [0, 0, 0] }

STEPS.times do
  apply_gravity(positions, velocities)
  apply_velocity(positions, velocities)
end

puts total_energy(positions, velocities)
