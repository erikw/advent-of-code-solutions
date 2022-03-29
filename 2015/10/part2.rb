#!/usr/bin/env ruby

seq = ARGF.readline.chomp.split('')

50.times do
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
