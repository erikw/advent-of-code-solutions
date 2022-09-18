#!/usr/bin/env ruby
# frozen_string_literal: true

require '../09/computer_iter'

COMPUTERS = 50
ADDR_NAT = 255
ADDR_WAKEUP = 0
EMPTY_RECV = -1

intcode = ARGF.readline.split(',').map(&:to_i)
computers = COMPUTERS.times.map do |i|
  Computer.new(intcode).tap do |computer|
    computer.stdin << i
    computer.execute
  end
end

nat_last = nil
wakeup_y_last = nil
loop do
  idle = true
  computers.each.with_index do |computer, _i|
    case computer.execute
    when Computer::STATUS_OUTPUT
      idle = false
      computer.execute
      computer.execute
      addr_dest, x, y = 3.times.map { computer.stdout.pop }

      if addr_dest == ADDR_NAT
        nat_last = [x, y]
      else
        computers[addr_dest].stdin << x
        computers[addr_dest].stdin << y
      end
    when Computer::STATUS_INPUT_NEEDED
      computer.stdin << EMPTY_RECV
    end
  end

  next unless idle && !nat_last.nil?

  computers[ADDR_WAKEUP].stdin << nat_last[0]
  computers[ADDR_WAKEUP].stdin << nat_last[1]

  if nat_last[1] == wakeup_y_last
    puts nat_last[1]
    exit
  else
    wakeup_y_last = nat_last[1]
  end
end
