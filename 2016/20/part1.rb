#!/usr/bin/env ruby

IP_LO = 0
IP_HI = 2**32 - 1

blocklist = {}
last = nil
# Merge overlapping ranges.
# (A)
# |-------------|
#       |-------------|
# (B)
# |-------------|
#       |----|
# (C)
# |---------|
#               |---------|
ARGF.each_line.map { |l| l.split('-').map(&:to_i) }.sort_by(&:first).each do |ip_start, ip_end|
  if !last.nil? && (last..blocklist[last]).cover?(ip_start)
    if ip_end > blocklist[last] # (A)
      blocklist[last] = ip_end
    else # (B)
      next
    end
  else # (C)
    blocklist[ip_start] = ip_end
    last = ip_start
  end
end

ip = IP_LO
ip = blocklist[ip] + 1 while blocklist.key?(ip)
puts ip
