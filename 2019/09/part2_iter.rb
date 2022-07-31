#!/usr/bin/env ruby

require_relative 'computer_iter'

intcode = ARGF.readline.split(',').map(&:to_i)
computer = Computer.new(intcode, stdin: Thread::Queue.new([2]))

status = nil
status = computer.execute until status == Computer::STATUS_DONE

puts computer.stdout.pop
