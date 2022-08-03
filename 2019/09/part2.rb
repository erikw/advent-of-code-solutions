#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'computer'

intcode = ARGF.readline.split(',').map(&:to_i)
puts Computer.new(stdin: Thread::Queue.new([2])).execute(intcode).stdout.pop
