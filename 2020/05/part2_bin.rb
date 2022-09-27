#!/usr/bin/env ruby

require 'set'
ROWS = 128
COLS = 8

seat_ids = ARGF.each_line.map do |line|
  # Convert to binary number -> directly seat_id
  line.gsub!(/F/, '0')
  line.gsub!(/B/, '1')
  line.gsub!(/L/, '0')
  line.gsub!(/R/, '1')
  line.to_i(2)
end.to_set

(ROWS * COLS).times do |exp_seat_id|
  if !seat_ids.include?(exp_seat_id) && seat_ids.include?(exp_seat_id - 1) && seat_ids.include?(exp_seat_id + 1)
    puts exp_seat_id
    exit
  end
end
