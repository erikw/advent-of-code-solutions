#!/usr/bin/env ruby
# frozen_string_literal: true

in_page_order, in_page_updates = ARGF.read.split("\n\n")

page_rules = Hash.new { |h, k| h[k] = Set.new } # page_num -> [pages_nums_need_to_come_after]
in_page_order.each_line.map { |l| l.chomp.split('|').map(&:to_i) }.each do |pnum_before, pnum_after|
  page_rules[pnum_before] << pnum_after
end

mid_page_sum = in_page_updates.each_line.map { |l| l.chomp.split(',').map(&:to_i) }.select do |page_nums|
  page_num_index = page_nums.each_with_index.to_h
  page_nums.each_with_index.all? do |page_num, i|
    page_rules[page_num].all? do |page_num_after|
      next true unless page_num_index.key?(page_num_after)

      i < page_num_index[page_num_after]
    end
  end
end.sum do |page_nums|
  page_nums[page_nums.length / 2]
end

puts mid_page_sum
