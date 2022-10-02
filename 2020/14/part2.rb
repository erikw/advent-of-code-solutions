#!/usr/bin/env ruby
# frozen_string_literal: true

masks = [] # [mask_0, mask_1]
mem = Hash.new(0)

ARGF.each_line do |line|
  lhs, rhs = line.chomp.split(' = ')
  if lhs == 'mask'
    masks.clear
    # 1 in mask should be 1
    mask_1_base = rhs.each_char.map { |c| c == '1' ? '1' : '0' }.join.to_i(2)

    # Generate all subsets of the n floats (i.e. powerset), by means of binary number 2^n
    n_floats = rhs.chars.count { |c| c == 'X' }
    (2**n_floats).times do |i|
      # The subset
      f_mask = i.to_s(2).rjust(n_floats, '0')
      f_pos = 0
      # Create a version of the mask corresponding to the subset of floats.
      mask_s = rhs.each_char.with_index.map do |c, _j|
        if c == 'X'
          f_pos += 1
          f_mask[f_pos - 1]
        else
          'X' # maps to problem1, so mask_s can be treated for same conversion as mask in prob1
        end
      end

      # Same as problem 1
      mask_1 = mask_s.each.map { |c| c == '1' ? '1' : '0' }.join.to_i(2)
      mask_0 = mask_s.each.map { |c| c == '0' ? '0' : '1' }.join.to_i(2)

      # Add the base 1s as they should be set always!
      masks << [mask_0, mask_1 | mask_1_base]
    end
  else
    val = rhs.to_i
    masks.each do |mask_0, mask_1|
      addr = lhs.scan(/\d+/).first.to_i
      addr |= mask_1
      addr &= mask_0
      mem[addr] = val
    end
  end
end

puts mem.values.sum
