#!/usr/bin/env ruby

require 'digest'

door_id = ARGF.readline.chomp

i = 0
hash = nil
password = 8.times.map do
  i += 1 until (hash = Digest::MD5.hexdigest("#{door_id}#{i}")).start_with?('0' * 5)
  i += 1
  hash[5]
end.join

puts password
