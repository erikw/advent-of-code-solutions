#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

cubes = Hash.new(false) # [x, y, z, w] -> state
ARGF.each_line.with_index do |line, x|
  line.chomp.each_char.with_index do |char, y|
    cubes[[x, y, 0, 0]] = char == SYM_ACTIVE
  end
end

run(cubes, BOOT_CYCLES)
puts cubes.values.count { |s| s }
