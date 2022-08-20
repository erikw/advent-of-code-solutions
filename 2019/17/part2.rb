#!/usr/bin/env ruby
# frozen_string_literal: true

require '../09/computer'

VERBOSE = false
ANSI_CLEAR_SCREEN = "\033c"

def answer(computer, answer)
  (answer + "\n").each_char.map(&:ord).each do |char|
    computer.stdin << char
  end
end

def read(computer, verbose = false)
  line = []
  until computer.stdout.empty?
    line << computer.stdout.pop
    next unless line.last == "\n".ord

    puts line.map(&:chr).join if verbose
    if line.length == 1 && verbose
      sleep 0.03
      puts ANSI_CLEAR_SCREEN
    end
    line.clear
  end
  puts line.join unless line.empty?
end

intcode = ARGF.readline.split(',').map(&:to_i)
intcode[0] = 2
computer = Computer.new
comp_thr = Thread.new { computer.execute(intcode) }

# Solved with paper and pen.
answer(computer, 'A,A,B,C,C,A,C,B,C,B')
answer(computer, 'L,4,L,4,L,6,R,10,L,6')
answer(computer, 'L,12,L,6,R,10,L,6')
answer(computer, 'R,8,R,10,L,6')
answer(computer, VERBOSE ? 'y' : 'n')

comp_thr.join
read(computer, VERBOSE)
