#!/usr/bin/env ruby
# frozen_string_literal: true

disk = ARGF.read.chomp.each_char.with_index.map do |c, i|
  len = c.to_i
  id = i.even? ? i / 2 : nil
  [len, id]
end
raise unless disk.length.odd?

idx_free = 1
idx_file = disk.length - 1

disk_compact = [disk[0][1]] * disk[0][0]
while idx_free < idx_file && idx_free.between?(1, disk.length - 1) && idx_file.between?(0, disk.length - 1)
  if disk[idx_free][0].zero?
    disk_compact.concat([disk[idx_free + 1][1]] * disk[idx_free + 1][0]) if (idx_free + 1) < disk.length
    idx_free += 2
    next
  end
  if disk[idx_file][0].zero?
    idx_file -= 2
    next
  end

  disk_compact << disk[idx_file][1]
  disk[idx_free][0] -= 1
  disk[idx_file][0] -= 1
end

checksum = disk_compact.each.with_index.sum { |id, idx| id * idx }
puts checksum
