#!/usr/bin/env ruby
# frozen_string_literal: true

# This was used to interactively play the game and explore the maze and collectible combinations.

require '../09/computer_iter'
require 'set'

VERBOSE = true
ANSI_CLEAR_SCREEN = "\033c"

def read(computer, print = true, clear: false)
  line = []
  lines = []
  until computer.stdout.empty?
    line << computer.stdout.pop
    next unless line.last == "\n".ord

    lines << line.map(&:chr).join
    puts line.map(&:chr).join if print
    if line.length == 1 && clear
      sleep 0.03
      puts ANSI_CLEAR_SCREEN
    end
    line.clear
  end
  puts line.join unless line.empty?
  lines.join("\n")
end

def answer(computer, answer, print = true)
  answer += "\n"
  puts answer if print
  answer.each_char.map(&:ord).each do |char|
    computer.stdin << char
  end
end

def run(computer)
  next until [Computer::STATUS_INPUT_NEEDED, Computer::STATUS_DONE].include? computer.execute
end

def print_map(map, cur_pos)
  xmin, xmax = map.map(&:real).minmax
  ymin, ymax = map.map(&:imag).minmax
  puts '=' * 30
  (xmin..xmax).each do |row|
    (ymin..ymax).each do |col|
      pos = Complex(row, col)
      if pos == cur_pos
        print '*'
      else
        print map.include?(pos) ? '.' : '?'
      end
    end
    puts
  end
  puts '=' * 30
end

intcode = ARGF.readline.split(',').map(&:to_i)
computer = Computer.new(intcode)

pos = 0 + 0i
map = Set[pos]
run(computer)
read(computer, VERBOSE)
loop do
  pos_incr = nil
  reply = case STDIN.gets.chomp
          when 'n'
            pos_incr = (-1 + 0i)
            'north'
          when 'w'
            pos_incr = (0 - 1i)
            'west'
          when 'e'
            pos_incr = (0 + 1i)
            'east'
          when 's'
            pos_incr = (1 + 0i)
            'south'
          when 'i' then 'inv'
          when /^t\s+(.*)$/
            "take #{Regexp.last_match(1)}"
          when /^d\s*(.*)$/
            "drop #{Regexp.last_match(1)}"
          end

  next if reply.nil?

  answer(computer, reply, false)

  run(computer)
  output = read(computer, VERBOSE)
  next if pos_incr.nil? || [/can't/, /(heavier|lighter) than/].any? { |p| output.match(p) }

  pos += pos_incr
  map << pos
  print_map(map, pos)
end
