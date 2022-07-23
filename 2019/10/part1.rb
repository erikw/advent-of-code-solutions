#!/usr/bin/env ruby
# Using atan2 is more reliable than using the straight line formula y=kx+m that I first tried. Also no edge-case with x = constant.

require_relative 'lib'

asteroids = read_input
_mon_asteroid, detectable = best_monitoring_asteroid(asteroids)
puts detectable
