#!/usr/bin/env ruby
# frozen_string_literal: true

def equation_values(numbers, index)
  if numbers.empty? || index.negative?
    []
  elsif index.zero?
    [numbers[0]]
  else
    lhs_values = equation_values(numbers[..index], index - 1)
    res_add = lhs_values.map { |v| v + numbers[index] }
    res_mul = lhs_values.map { |v| v * numbers[index] }
    res_add + res_mul
  end
end

def equation_possible?(result, numbers)
  equation_values(numbers, numbers.length - 1).any?(result)
end

equations = ARGF.each_line(chomp: true).map(&:split).map do |num_line|
  res, *nums = num_line.map(&:to_i)
  [res, nums]
end

equations_possible = equations.select { |res, nums| equation_possible?(res, nums) }

calibration_result = equations_possible.map(&:first).sum
puts calibration_result
