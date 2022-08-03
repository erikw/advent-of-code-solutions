#!/usr/bin/env ruby
# frozen_string_literal: true

captcha = ARGF.readline.chomp.split('').map(&:to_i)
captcha << captcha.first
puts captcha.each_cons(2).sum { |a, b| a == b ? a : 0 }
