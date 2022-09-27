#!/usr/bin/env ruby

seatsid_max = ARGF.each_line.map do |line|
  # Convert to binary number -> directly seat_id
  line.gsub!(/F/, '0')
  line.gsub!(/B/, '1')
  line.gsub!(/L/, '0')
  line.gsub!(/R/, '1')
  line.to_i(2)
end.max
puts seatsid_max
