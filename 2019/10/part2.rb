#!/usr/bin/env ruby
# Algorithm
# 1. Find the asteroid to put the monitoring station with laser gun on.
# 2. Group the other asteroid by it's polar coordniate's angle
#    * Transform to be in the range [-3PI/2, PI/2]
# 3. Sort each grouping by the polar coordinate's length
# 4. Until we've vaporized 200 asteroids, go angle by angle in clock-wise order and wipe the closest one (by polar coordinate length) on that angle.

require_relative 'lib'

NTH = 200

asteroids = read_input
mon_asteroid, _detectable = best_monitoring_asteroid(asteroids)

asteroids_by_angle = Hash.new { |h, k| h[k] = [] }
asteroids.reject { |c| c == mon_asteroid }.each do |asteroid|
  dr = asteroid.imag - mon_asteroid.imag
  dc = asteroid.real - mon_asteroid.real
  angle = Math.atan2(-dr, dc) # Transform Y axis to go from bottom to up.
  angle -= 2 * Math::PI if angle > Math::PI / 2 # Angles now in [-3Pi/2, Pi/2]
  asteroids_by_angle[angle] << asteroid
end

asteroids_by_angle.keys.each do |angle|
  asteroids_by_angle[angle].sort_by! do |asteroid|
    asteroid.real**2 + asteroid.imag**2
  end.reverse!
end

i = 0
until asteroids_by_angle.empty?
  asteroids_by_angle.keys.sort.reverse.each do |angle|
    asteroid = asteroids_by_angle[angle].pop
    asteroids_by_angle.delete(angle) if asteroids_by_angle[angle].empty?
    i += 1
    next unless i == NTH

    puts asteroid.real * 100 + asteroid.imag
    exit
  end
end
