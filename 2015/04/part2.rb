#!/usr/bin/env ruby
# frozen_string_literal: true

require 'digest'

key = ARGF.readline.chomp
n = 0
n += 1 until Digest::MD5.hexdigest(key + n.to_s)[0, 6] == '0' * 6
puts n
