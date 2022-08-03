#!/usr/bin/env ruby
# frozen_string_literal: true

require 'digest'

key = ARGF.readline.chomp
n = 0
n += 1 until Digest::MD5.hexdigest(key + n.to_s)[0, 5] == '0' * 5
puts n
