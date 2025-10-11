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

# Topological sort, considering the rules as edges.
# def topological_insert_sort(pages, rules)
#  sorted = []
#  pages.each do |page|
#    i = 0
#    i += 1 while i < sorted.length && !rules[page].include?(sorted[i])
#    sorted.insert(i, page)
#  end
#  sorted
# end

# Topological sort, considering the rules as edges.
def topological_insert_sort(pages, rules)
  sorted = []
  pages.each do |page|
    idx = sorted.find_index { |p| rules[page].include?(p) } || sorted.length
    sorted.insert(idx, page)
  end
  sorted
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

updates_incorrect = updates.reject { |pages| valid_update?(pages, rules) }
updates_corrected = updates_incorrect.map { |pages| topological_insert_sort(pages, rules) }

mid_page_sum = updates_corrected.sum do |pages|
  pages[pages.length / 2]
end

puts mid_page_sum
