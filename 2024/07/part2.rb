#!/usr/bin/env ruby
# frozen_string_literal: true

def equation_values(numbers, index)
  number = numbers[index]
  if numbers.empty? || index.negative?
    []
  elsif index.zero?
    [number]
  else
    equation_values(numbers, index - 1).flat_map do |v|
      [v + number, v * number, (v.to_s + number.to_s).to_i]
    end
  end
end

def equation_possible?(target, numbers)
  equation_values(numbers, numbers.length - 1).include?(target)
end

equations = ARGF.each_line(chomp: true).map do |num_line|
  target, *nums = num_line.split.map(&:to_i)
  [target, nums]
end

equations_possible = equations.select { |res, nums| equation_possible?(res, nums) }
calibration_result = equations_possible.map(&:first).sum
puts calibration_result
