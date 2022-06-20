#!/usr/bin/env ruby

def metadata_sum(numbers, pos = -1)
  children = numbers[pos += 1]
  metadata = numbers[pos += 1]
  sum_total = 0
  children.times do
    pos, sum = metadata_sum(numbers, pos)
    sum_total += sum
  end
  metadata.times do
    sum_total += numbers[pos += 1]
  end
  [pos, sum_total]
end

numbers = ARGF.readline.split.map(&:to_i)
puts metadata_sum(numbers)[1]
