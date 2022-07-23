require 'set'

SYM_ASTEROID = '#'

def read_input
  asteroids = []
  ARGF.each_line.with_index do |line, y|
    line.chomp.chars.each_with_index do |char, x|
      asteroids << Complex(x, y) if char == SYM_ASTEROID
    end
  end
  asteroids
end

def best_monitoring_asteroid(asteroids)
  asteroids.map do |origin|
    angles = Set.new
    asteroids.reject { |c| c == origin }.each do |asteroid|
      dr = asteroid.imag - origin.imag
      dc = asteroid.real - origin.real
      angles << Math.atan2(dr, dc)
    end
    [origin, angles.length]
  end.max_by(&:last)
end
