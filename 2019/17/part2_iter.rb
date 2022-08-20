#!/usr/bin/env ruby
# frozen_string_literal: true

require '../09/computer_iter'

VERBOSE = false
ANSI_CLEAR_SCREEN = "\033c"

def read(computer, print = true, clear: false)
  line = []
  until computer.stdout.empty?
    line << computer.stdout.pop
    next unless line.last == "\n".ord

    puts line.map(&:chr).join if print
    if line.length == 1 && clear
      sleep 0.03
      puts ANSI_CLEAR_SCREEN
    end
    line.clear
  end
  puts line.join unless line.empty?
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

intcode = ARGF.readline.split(',').map(&:to_i)
intcode[0] = 2
computer = Computer.new(intcode)

run(computer)
read(computer, VERBOSE)

answer(computer, 'A,A,B,C,C,A,C,B,C,B', VERBOSE)
run(computer)
read(computer, VERBOSE)

answer(computer, 'L,4,L,4,L,6,R,10,L,6', VERBOSE)
run(computer)
read(computer, VERBOSE)

answer(computer, 'L,12,L,6,R,10,L,6', VERBOSE)
run(computer)
read(computer, VERBOSE)

answer(computer, 'R,8,R,10,L,6', VERBOSE)
run(computer)
read(computer, VERBOSE)

answer(computer, VERBOSE ? 'y' : 'n', VERBOSE)
run(computer)

read(computer, VERBOSE, clear: VERBOSE)
