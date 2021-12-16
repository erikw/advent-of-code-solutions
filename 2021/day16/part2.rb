#!/usr/bin/env ruby

def consume_digits(digitstring, length)
  digitstring.slice!(0, length)
end

def parse_subpacks_by_nbr_bits(digits, nbr_bits)
  start_len = digits.length
  values = []
  while start_len - digits.length < nbr_bits
    value = parse(digits)
    break if value.nil?

    values << value
  end
  values
end

def parse_subpacks_by_nbr_packs(digits, nbr_packs)
  packs = 0
  values = []
  while packs < nbr_packs
    value = parse(digits)
    break if value.nil?

    values << value
    packs += 1
  end
  values
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

def parse_subpacks(digits)
  length_type_id = consume_digits(digits, 1).to_i(2)
  if length_type_id == 0
    length = consume_digits(digits, 15).to_i(2)
    parse_subpacks_by_nbr_bits(digits, length)
  else
    length = consume_digits(digits, 11).to_i(2)
    parse_subpacks_by_nbr_packs(digits, length)
  end
end

def parse(digits)
  return nil if digits.length < 11

  _version = consume_digits(digits, 3).to_i(2)
  type_id = consume_digits(digits, 3).to_i(2)
  case type_id
  when 0
    parse_subpacks(digits).sum
  when 1
    parse_subpacks(digits).inject(&:*)
  when 2
    parse_subpacks(digits).min
  when 3
    parse_subpacks(digits).max
  when 4
    parse_literal_value(digits)
  when 5
    parse_subpacks(digits).each_cons(2).all? { |a, b| a > b } ? 1 : 0
  when 6
    parse_subpacks(digits).each_cons(2).all? { |a, b| a < b } ? 1 : 0
  when 7
    parse_subpacks(digits).each_cons(2).all? { |a, b| a == b } ? 1 : 0
  end
end

ARGF.each_line do |line|
  digits = line.hex.to_s(2).rjust(4 * (line.length - 1), '0')
  puts parse(digits)
end
