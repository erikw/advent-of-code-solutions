# frozen_string_literal: true

# Hats off to https://github.com/mebeim/aoc/blob/master/2021/README.md#day-24---arithmetic-logic-unit

MODNUM_LEN = 14

def skip_lines(io, num)
  num.times { io.readline }
end

def next_op(io)
  io.readline.strip
end

def find_constraints(io)
  constraints = []
  stack = []

  MODNUM_LEN.times do |i|
    skip_lines(io, 4)
    op = next_op(io)

    if op == 'div z 1'
      skip_lines(io, 10)
      op = next_op(io)
      a = op.split.last.to_i
      stack << [i, a]
      skip_lines(io, 2)
    else
      op = next_op(io)
      b = op.split.last.to_i
      j, a = stack.pop
      constraints << [i, j, a + b]
      skip_lines(io, 12)
    end
  end
  constraints
end

def solve(constraints)
  max = Array.new(0, MODNUM_LEN)
  min = Array.new(0, MODNUM_LEN)

  constraints.each do |i, j, diff|
    if diff > 0
      max[i] = 9
      max[j] = 9 - diff

      min[i] = 1 + diff
      min[j] = 1
    else
      max[i] = 9 + diff
      max[j] = 9

      min[i] = 1
      min[j] = 1 - diff
    end
  end
  maxi = max.inject { |acc, d| acc * 10 + d }
  mini = min.inject { |acc, d| acc * 10 + d }
  [maxi, mini]
end
