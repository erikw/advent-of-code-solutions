#!/usr/bin/env ruby
# frozen_string_literal: true

# TARGET = 25
TARGET = 150

containers = ARGF.each_line.map(&:to_i)
(1..containers.length).each do |n|
  nbr = containers.combination(n).map(&:sum).select { |s| s == TARGET }.count
  unless nbr.zero?
    puts nbr
    break
  end
end
