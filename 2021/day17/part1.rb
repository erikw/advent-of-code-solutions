#!/usr/bin/env ruby

x_range, y_range = ARGF.readline.chomp.delete_prefix!('target area: ').gsub!(/.=/, '').split(', ').map do |part|
  part.split('..').map(&:to_i)
end

# h_max = -Float::INFINITY
# (1...x_range[1] + 1).each do |vx|
# (0...y_range[0].abs + 1).each do |vy|
## (1..200).each do |t|
# t = 0
# loop do
# t += 1
# xd = (0..(t - 1)).map { |i| vx - i }.sum
# if vy <= 0
# h = 0
# yd = (0..(t - 1)).map { |i| vy + i }.sum
# else
# h = (0..vy).map { |i| vy - i }.sum
# yd = h - (1..(t - vy - 1)).sum
# end
## puts "NEGATIVE Velocities (#{vx}, #{vy}) leeads to a landing at (#{xd}, #{yd}) in range (#{x_range}, #{y_range}) after time #{t} at max height #{h}"
# break if xd < 0 || yd < y_range[0]
# next unless xd.between?(*x_range) && yd.between?(*y_range)

# puts "POSITIVE Velocities (#{vx}, #{vy}) leeads to a landing at (#{xd}, #{yd}) in range after time #{t} at max height #{h}"
# if h > h_max
# h_max = h
# puts "\nNew h_max: #{h_max}"
# end
# end
# end
# end
# puts h_max

h_max = -Float::INFINITY
(0...y_range[0].abs + 1).each do |t|
  (1..t).each do |vy|
    # h = (0..vy).map { |i| i }.sum
    # yd = h - (1..t).sum
    h = vy * (vy + 1) / 2
    yd = h - t * (t + 1) / 2
    next unless yd.between?(*y_range)

    h_max = [h, h_max].max
  end
end
puts h_max
