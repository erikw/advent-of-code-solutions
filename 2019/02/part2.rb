#!/usr/bin/env ruby

require_relative 'computer'

SEARCHED = 19_690_720
VAL_RANGE = 0..99

def compute(computer, intcode, noun, verb)
  intcode[IP_NOUN] = noun
  intcode[IP_VERB] = verb
  computer.execute(intcode).memory[0]
end

intcode = ARGF.readline.split(',').map(&:to_i)

noun = 0
verb = 0
computer = Computer.new
catch :found do
  VAL_RANGE.each do |n|
    VAL_RANGE.each do |v|
      next unless compute(computer, intcode, n, v) == SEARCHED

      noun = n
      verb = v
      throw :found
    end
  end
end
puts 100 * noun + verb
