#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

WIN_LEN = 3

tls = ARGF.each_line.map(&:chomp).count do |line|
  hypernet = false
  window = []
  valid = false
  abas = Set.new
  babs = Set.new
  line.each_char do |c|
    case c
    when '['
      hypernet = true
      window = []
    when ']'
      hypernet = false
      window = []
    else
      window.shift unless window.length < WIN_LEN
      window << c
      next unless window.length >= WIN_LEN && window[0] == window[2] && window[0] != window[1]

      add, check = hypernet ? [babs, abas] : [abas, babs]
      add << [window[1], window[0], window[1]]
      if check.include?(window)
        valid = true
        break
      end
    end
  end
  valid
end
puts tls
