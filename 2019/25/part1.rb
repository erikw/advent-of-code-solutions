#!/usr/bin/env ruby
# frozen_string_literal: true

# The scripted version after manually finding the answer with part1_interactive.rb.
# Need: sand, astronaut ice cream, boule, mutex

require '../09/computer_iter'

COMMANDS = [
  'north',
  'west',
  'take sand',
  'east',
  'south',
  'east',
  'east',
  'north',
  'east',
  'east',
  'take astronaut ice cream',
  'west',
  'west',
  'south',
  'west',
  'west',
  'south',
  'south',
  'take mutex',
  'south',
  'take boulder',
  'east',
  'south',
  'east'
]

def read(computer)
  line = []
  lines = []
  until computer.stdout.empty?
    line << computer.stdout.pop
    next unless line.last == "\n".ord

    lines << line.map(&:chr).join
  end
  lines.join("\n")
end

def answer(computer, answer)
  answer += "\n"
  answer.each_char.map(&:ord).each do |char|
    computer.stdin << char
  end
end

def run(computer)
  next until [Computer::STATUS_INPUT_NEEDED, Computer::STATUS_DONE].include? computer.execute
end

intcode = ARGF.readline.split(',').map(&:to_i)
computer = Computer.new(intcode)

run(computer)
read(computer)
output = nil
COMMANDS.each do |command|
  answer(computer, command)
  run(computer)
  output = read(computer)
end

password = output.scan(/\d+/)
puts password
