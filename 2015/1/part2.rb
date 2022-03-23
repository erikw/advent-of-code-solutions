#!/usr/bin/env ruby

floor = 0
instruction = 0
ARGF.readline.split('').each do |c|
  instruction += 1
  case c
  when '('
    floor += 1
  when ')'
    floor -= 1
  end
  if floor == -1
    puts instruction
    return
  end
end
