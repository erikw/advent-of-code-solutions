#!/usr/bin/env ruby
# frozen_string_literal: true

# require 'set'

# FLOORS = 4

# def print_floors(floors, elevator)
#  (FLOORS - 1).downto(0).each do |i|
#    rep = floors[i].map do |e|
#      if e.nil?
#        '. '
#      else
#        e.map { |w| w[0].upcase }.join
#      end
#    end.join(' ')
#    evstr = elevator == i ? 'E ' : '. '
#    puts "F#{i + 1} #{evstr} #{rep}"
#  end
# end

# floor_items = Array.new(FLOORS) { [] }
# (FLOORS - 1).times do |i|
#  components = ARGF.readline.gsub(/^(\w+ ){4}/, '').gsub(/(,? and a)/, ', a').gsub(/\.$/, '').strip.split(',')
#  components.map do |c|
#    m = c.strip.match(/a (\w+)(?:-compatible)? (\w+)/)
#    floor_items[i] << [m[1], m[2]]
#  end
# end

# nitems = floor_items.sum { |f| f.length }
# floors = Array.new(FLOORS) { [nil] * nitems }
# j = 0
# floor_items.each_with_index do |items, i|
#  items.each do |item|
#    puts "[#{i}][#{j}] = #{item}"
#    floors[i][j] = item
#    j += 1
#  end
# end

# elevator = 0
# moves = 0
# while floors.last.any?(&:nil?)
#  puts '=' * 20
#  print_floors(floors, elevator)
#  next if elevator == FLOORS - 1

#  floors[elevator].each_with_index do |e, i|
#    chip_moveable = (!e.nil? &&
#                e[1] == 'microchip' &&
#                (
#                  floors[elevator + 1].all? { |e2| e2.nil? || e2[1] == 'generator' } \
#                  ||
#                  floors[elevator + 1].any? { |e2| !e2.nil? && e2[0] == e[0] && e2[1] == 'generator' }
#                ))
#    next unless chip_moveable

#    gen_index = floors[elevator].each_with_index.select do |e2, _|
#      !e2.nil? && e2[0] == e[0] && e2[1] == 'generator'
#    end.map(&:last).first

#    floors[elevator + 1][i] = e
#    floors[elevator][i] = nil
#    unless gen_index.nil?
#      floors[elevator + 1][gen_index] = floors[elevator][gen_index]
#      floors[elevator][gen_index] = nil
#    end
#    elevator += 1
#    moves += 1
#    break
#  end
# end

puts 37  # Found with pen-and-paper game.
