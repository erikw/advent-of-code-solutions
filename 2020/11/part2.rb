#!/usr/bin/env ruby
# frozen_string_literal: true

SYM_FLOOR = '.'
SYM_EMPTY = 'L'
SYM_OCCUPIED = '#'

ADJ_DELTA = [
  0 - 1i,
  -1 - 1i,
  -1 + 0i,
  -1 + 1i,
  0 + 1i,
  1 + 1i,
  1 + 0i,
  1 - 1i
]

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
  ADJ_DELTA.count do |delta|
    pos_adj = pos + delta
    pos_adj += delta while seats.has_key?(pos_adj) && seats[pos_adj] == SYM_FLOOR
    seats[pos_adj] == SYM_OCCUPIED
  end
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
      elsif seats[pos] == SYM_OCCUPIED && adj_occupant >= 5
        seats_next[pos] = SYM_EMPTY
      end
    end
  end
  # print_grid(seats_next)
  break if seats == seats_next

  seats = seats_next
end

puts seats.values.count { |s| s == SYM_OCCUPIED }
