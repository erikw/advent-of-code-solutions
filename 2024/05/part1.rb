#!/usr/bin/env ruby
# frozen_string_literal: true

def valid_update?(pages, rules)
  index_by_page = pages.each_with_index.to_h
  pages.all? do |page|
    rules[page].all? do |page_after|
      !index_by_page.key?(page_after) || index_by_page[page] < index_by_page[page_after]
    end
  end
end

input_rules, input_updates = ARGF.read.split("\n\n")

rules = Hash.new { |h, k| h[k] = Set.new } # page -> [pages_nums_need_to_come_after]
input_rules.each_line(chomp: true) do |line|
  before, after = line.split('|').map(&:to_i)
  rules[before] << after
end

updates = input_updates.each_line(chomp: true).map do |l|
  l.split(',').map(&:to_i)
end

updates_correct = updates.select { |pages| valid_update?(pages, rules) }
mid_page_sum = updates_correct.sum { |pages| pages[pages.length / 2] }
puts mid_page_sum
