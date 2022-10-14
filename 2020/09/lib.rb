# frozen_string_literal: true

require 'set'

# PREAMBLE = 5
PREAMBLE = 25

def first_invalid(numbers_input)
  numbers = numbers_input.reverse
  win_que = []
  win_count = Hash.new(0)

  PREAMBLE.times do
    num = numbers.pop
    win_que << num
    win_count[num] += 1
  end

  until numbers.empty?
    num = numbers.pop
    adds_up = win_que.any? do |x|
      y = num - x
      win_count[y] > 0
    end
    return num unless adds_up

    old = win_que.shift
    win_count[old] -= 1
    win_count.delete(old) if win_count[old] == 0

    win_que << num
    win_count[num] += 1
  end
  nil
end
