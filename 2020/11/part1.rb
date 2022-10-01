#!/usr/bin/env ruby
# frozen_string_literal: true

SYM_FLOOR = '.'
SYM_EMPTY = 'L'
SYM_OCCUPIED = '#'

ADJ = [-1, 0, 1]

def print_grid(seats)
  rmin, rmax = seats.keys.map(&:real).minmax
  cmin, cmax = seats.keys.map(&:imag).minmax
  (rmin..rmax).each do |row|
    (cmin..cmax).each do |col|
      pos = Complex(row, col)
      print seats[pos]
    end
    puts
  end
end

def adjacent_occupied(seats, pos)
  occupied = 0
  ADJ.each do |dr|
    ADJ.each do |dc|
      next if dr == 0 && dc == 0

      pos_adj = Complex(pos.real + dr, pos.imag + dc)
      occupied += 1 if seats[pos_adj] == SYM_OCCUPIED
    end
  end
  occupied
end

seats = Hash.new(SYM_FLOOR) # Complex -> floor tile
ARGF.each_line.with_index do |line, row|
  line.chomp.each_char.with_index do |c, col|
    pos = Complex(row, col)
    seats[pos] = c
  end
end

# print_grid(seats)

rmin, rmax = seats.keys.map(&:real).minmax
cmin, cmax = seats.keys.map(&:imag).minmax
loop do
  seats_next = seats.dup
  (rmin..rmax).each do |row|
    (cmin..cmax).each do |col|
      pos = Complex(row, col)
      next if seats[pos] == SYM_FLOOR

      pos = Complex(row, col)
      adj_occupant = adjacent_occupied(seats, pos)
      if seats[pos] == SYM_EMPTY && adj_occupant == 0
        seats_next[pos] = SYM_OCCUPIED
      elsif seats[pos] == SYM_OCCUPIED && adj_occupant >= 4
        seats_next[pos] = SYM_EMPTY
      end
    end
  end
  break if seats == seats_next

  seats = seats_next
end

puts seats.values.count { |s| s == SYM_OCCUPIED }
