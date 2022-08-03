#!/usr/bin/env ruby
# frozen_string_literal: true

measurements = ARGF.each_line.map(&:to_i)
count = (1...measurements.length).count { |i| measurements[i] > measurements[i - 1] }
puts count
