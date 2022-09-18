#!/usr/bin/env ruby
# frozen_string_literal: true

require '../09/computer_iter'

COMPUTERS = 50
ADDR_SEARCH = 255
EMPTY_RECV = -1

intcode = ARGF.readline.split(',').map(&:to_i)
computers = COMPUTERS.times.map do |i|
  Computer.new(intcode).tap do |computer|
    computer.stdin << i
    computer.execute
  end
end

loop do
  computers.each.with_index do |computer, _i|
    case computer.execute
    when Computer::STATUS_OUTPUT
      computer.execute
      computer.execute
      addr_dest, x, y = 3.times.map { computer.stdout.pop }
      if addr_dest == ADDR_SEARCH
        puts y
        exit
      end
      computers[addr_dest].stdin << x
      computers[addr_dest].stdin << y

    when Computer::STATUS_INPUT_NEEDED
      computer.stdin << EMPTY_RECV
    end
  end
end
