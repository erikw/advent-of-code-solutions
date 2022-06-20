#!/usr/bin/env ruby

def value(numbers, pos = -1)
  children = numbers[pos += 1]
  metadata = numbers[pos += 1]
  child_values = Array.new(children)
  children.times do |i|
    pos, value = value(numbers, pos)
    child_values[i] = value
  end

  value_total = 0
  if children.zero?
    metadata.times { value_total += numbers[pos += 1] }
  else
    metadata.times do
      m = numbers[pos += 1] - 1
      next unless m.between?(0, child_values.length - 1)

      value_total += child_values[m]
    end
  end
  [pos, value_total]
end

numbers = ARGF.readline.split.map(&:to_i)
puts value(numbers)[1]
