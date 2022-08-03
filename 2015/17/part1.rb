#!/usr/bin/env ruby
# frozen_string_literal: true

# TARGET = 25
TARGET = 150

containers = ARGF.each_line.map(&:to_i)
combinations = (1..containers.length).sum do |n|
  containers.combination(n).map(&:sum).count { |s| s == TARGET }
end
puts combinations
