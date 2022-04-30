#!/usr/bin/env ruby

require 'digest'

KEYS_NEEDED = 64
HASH_MAX_DIST = 1000
HASH_ITERATIONS = 2016

def gen_hash(salt, i)
  hash = Digest::MD5.hexdigest("#{salt}#{i}")
  HASH_ITERATIONS.times do
    hash = Digest::MD5.hexdigest(hash)
  end
  hash
end

def first_repeated3(str)
  m = str.match(/(.)\1{2}/)
  m ? m[1] : nil
end

def repeated5s(str)
  str.scan(/(.)\1{4}/).flatten.uniq
end

salt = ARGF.readline.chomp
i = -1
keys_found = 0
unmatched3s = Hash.new { |h, k| h[k] = [] }  # Char => [indices]
last_key_idx = nil

catch(:found) do
  loop do
    i += 1
    hash = gen_hash(salt, i)

    repeated5s(hash).each do |c5|
      unmatched3s[c5].each do |c3i|
        next unless (i - c3i) <= HASH_MAX_DIST

        keys_found += 1
        last_key_idx = c3i
        throw :found if keys_found == KEYS_NEEDED
      end
      unmatched3s[c5].clear
    end

    c3 = first_repeated3(hash)
    unmatched3s[c3] << i unless c3.nil?
  end
end

puts last_key_idx
