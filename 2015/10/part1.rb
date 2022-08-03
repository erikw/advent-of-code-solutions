#!/usr/bin/env ruby
# frozen_string_literal: true

seq = ARGF.readline.chomp.split('')

40.times do
  nseq = []
  digit = seq.first
  count = 1
  (1...seq.length).each do |i|
    if seq[i] == digit
      count += 1
    else
      nseq << count.to_s << digit
      digit = seq[i]
      count = 1
    end
  end
  nseq << count.to_s << digit
  seq = nseq
end
puts seq.length
