#!/usr/bin/env ruby

CODE_ONE = 20_151_125
TERM = 252_533
DIV = 33_554_393

crow, ccol = ARGF.readline.match(/(\d+),.+?(\d+)\./)[1..2].map(&:to_i)
row = 1
col = 1
code = CODE_ONE

loop do
  row -= 1
  col += 1
  if row == 0
    row = col
    col = 1
  end
  code = (code * TERM) % DIV
  break if row == crow && col == ccol
end

puts code
