#!/usr/bin/env ruby

MARKER = /\((\d+)x(\d+)\)/

compressed = ARGF.readline.chomp
decompressed = []
i = 0
while i < compressed.length
  if compressed[i] == '('
    len, rep, jump = compressed.match(MARKER, i) do |match|
      match.nil? ? [nil, nil] : [match[1].to_i, match[2].to_i, match[0].length]
    end
    decompressed << compressed[i + jump, len] * rep
    i += jump + len
  else
    decompressed << compressed[i]
    i += 1
  end
end

len = decompressed.join.each_char.count { |c| c != ' ' }
puts len
