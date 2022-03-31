#!/usr/bin/env ruby

require 'json'

class Object
  def sum_nums
    case self
    when Hash
      return 0 if values.any? { |v| v == 'red' }

      values.map(&:sum_nums).sum
    when Array then map(&:sum_nums).sum
    when Numeric then self
    else 0
    end
  end
end

puts JSON.parse(ARGF.readline).sum_nums
