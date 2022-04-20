#!/usr/bin/env ruby

require 'digest'

PW_LEN = 8

door_id = ARGF.readline.chomp

i = 0
hash = nil
password = [nil] * PW_LEN
while password.any?(&:nil?)
  i += 1 until (hash = Digest::MD5.hexdigest("#{door_id}#{i}")).start_with?('0' * 5)
  i += 1
  next unless hash[5].match?(/\d/)

  j = hash[5].to_i
  password[j] = hash[6] if j.between?(0, PW_LEN - 1) && password[j].nil?
end

puts password.join
