#!/usr/bin/env ruby
# frozen_string_literal: true

def consume_digits(digitstring, length)
  digitstring.slice!(0, length)
end

def parse_subpacks_by_bits(digits, nobits)
  start_len = digits.length
  versions = 0
  while start_len - digits.length < nobits
    v = parse(digits)
    break if v.nil?

    versions += v
  end
  versions
end

def parse_subpacks_by_nopacks(digits, nopacks)
  packs = 0
  versions = 0
  while packs < nopacks

    v = parse(digits)
    break if v.nil?

    versions += v
    packs += 1
  end
  versions
end

def parse_literal_value(digits)
  literal_str = ''
  loop do
    chunk = consume_digits(digits, 5)
    literal_str += chunk[1, 4]
    break if chunk[0] == '0' || digits.length < 5
  end
  literal_str.to_i(2)
end

def parse(digits)
  return nil if digits.length < 11

  versions = consume_digits(digits, 3).to_i(2)
  type_id = consume_digits(digits, 3).to_i(2)
  case type_id
  when 4
    literal_value = parse_literal_value(digits)
  else
    length_type_id = consume_digits(digits, 1).to_i(2)
    if length_type_id == 0
      length = consume_digits(digits, 15).to_i(2)
      versions += parse_subpacks_by_bits(digits, length)
    else
      length = consume_digits(digits, 11).to_i(2)
      versions += parse_subpacks_by_nopacks(digits, length)
    end
  end
  versions
end

ARGF.each_line do |line|
  digits = line.hex.to_s(2)
  puts parse(digits)
end
