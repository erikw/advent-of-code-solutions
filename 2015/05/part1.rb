#!/usr/bin/env ruby

require 'set'

VOWELS = %w[a e i o u]
BLOCK = Set.new(%w[ab cd pq xy])

nice = 0
ARGF.each_line.map(&:chomp).each do |string|
  freq = Hash.new(0)
  repeated = false
  blocked = false
  prev = nil
  string.each_char do |c|
    freq[c] += 1
    unless prev.nil?
      repeated ||= prev == c
      if BLOCK.include? prev + c
        blocked = true
        break
      end
    end
    prev = c
  end
  vowels = VOWELS.map { |v| freq[v] }.sum
  nice += 1 if vowels >= 3 && repeated && !blocked
end

puts nice
