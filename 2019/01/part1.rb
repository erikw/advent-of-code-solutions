#!/usr/bin/env ruby
# frozen_string_literal: true

puts ARGF.each_line.map { |l| l.to_i / 3 - 2 }.sum
