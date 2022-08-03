#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

polymer = ARGF.readline.chomp.chars
puts react(polymer).length
