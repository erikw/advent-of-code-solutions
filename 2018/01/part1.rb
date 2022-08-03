#!/usr/bin/env ruby
# frozen_string_literal: true

puts ARGF.each_line.map(&:to_i).sum
