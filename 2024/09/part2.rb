#!/usr/bin/env ruby
# frozen_string_literal: true

disk = ARGF.read.chomp.each_char.with_index.map do |c, i|
  len = c.to_i
  id = i.even? ? i / 2 : nil # id==nil means free space block.
  [len, id]
end
raise unless disk.length.odd?

(disk.length - 1).downto(1) do |file_idx|
  file_len, file_id = disk[file_idx]
  next if file_id.nil?

  free_idx = 1
  free_idx += 1 while free_idx < file_idx && !(disk[free_idx][1].nil? && disk[free_idx][0] >= file_len)
  next unless free_idx < file_idx

  disk[file_idx] = [file_len, nil]
  disk[free_idx][0] -= file_len
  disk.insert(free_idx, [file_len, file_id])
end

# puts disk.map { |len, id| (id.nil? ? '.' : id.to_s) * len }.join

checksum = disk.flat_map { |len, id| [id || 0] * len }.each_with_index.sum { |n, i| n * i }
puts checksum
