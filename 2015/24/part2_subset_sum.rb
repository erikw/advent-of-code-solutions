#!/usr/bin/env ruby
# frozen_string_literal: true

# Returns [min_items_first_group, quantum_entanglements]
def pack_sleigh(items, i,
                a_target, b_target, c_target, d_target,
                a_items = [], b_items = [], c_items = [], d_items = [], cache = {})
  if a_target == 0 && b_target == 0 && c_target == 0 && d_target == 0
    return [a_items, b_items, c_items, d_items].sort_by do |items|
             items.length
           end.map { |items| [items.length, items.inject(&:*)] }[0]
  elsif i < 0
    return [Float::INFINITY, []]
  end

  key = [i, a_target, b_target, c_target, d_target]
  unless cache.key? key
    a_subsets = [Float::INFINITY, []]
    if a_target - items[i] >= 0
      a_subsets = pack_sleigh(items, i - 1,
                              a_target - items[i], b_target, c_target, d_target,
                              a_items + [items[i]], b_items, c_items, d_items, cache)
    end
    b_subsets = [Float::INFINITY, []]
    if b_target - items[i] >= 0
      b_subsets = pack_sleigh(items, i - 1,
                              a_target, b_target - items[i], c_target, d_target,
                              a_items, b_items + [items[i]], c_items, d_items, cache)
    end
    c_subsets = [Float::INFINITY, []]
    if c_target - items[i] >= 0
      c_subsets = pack_sleigh(items, i - 1,
                              a_target, b_target, c_target - items[i], d_target,
                              a_items, b_items, c_items + [items[i]], d_items, cache)
    end
    d_subsets = [Float::INFINITY, []]
    if d_target - items[i] >= 0
      d_subsets = pack_sleigh(items, i - 1,
                              a_target, b_target, c_target, d_target - items[i],
                              a_items, b_items, c_items, d_items + [items[i]], cache)
    end

    cache[key] = [a_subsets, b_subsets, c_subsets, d_subsets].group_by(&:first).sort[0][1].min_by(&:last)
  end

  cache[key]
end

packages = ARGF.readlines.map(&:to_i)
total = packages.sum
puts pack_sleigh(packages, packages.length - 1, total / 4, total / 4, total / 4, total / 4)[1]
