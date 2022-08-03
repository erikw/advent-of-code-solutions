#!/usr/bin/env ruby
# frozen_string_literal: true

require 'digest'

KEYS_NEEDED = 64
HASH_MAX_DIST = 1000

def gen_hash(salt, i)
  Digest::MD5.hexdigest("#{salt}#{i}")
end

def first_repeated3(str)
  m = str.match(/(.)\1{2}/)
  m ? m[1] : nil
end

salt = ARGF.readline.chomp
i = -1
keys_found = 0

until keys_found == KEYS_NEEDED
  i += 1
  hash1 = gen_hash(salt, i)
  c3 = first_repeated3(hash1)
  next if c3.nil?

  j = i + 1
  while j < i + HASH_MAX_DIST
    hash2 = gen_hash(salt, j)
    if hash2.include?(c3 * 5)
      keys_found += 1
      break
    end
    j += 1
  end
end

puts i
