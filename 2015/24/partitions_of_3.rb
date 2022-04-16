def subset_sums_of_3(items, i, a_target, b_target, c_target, a_items = [], b_items = [], c_items = [], cache = {})
  if a_target == 0 && b_target == 0 && c_target == 0
    return [[a_items, b_items, c_items].sort_by { |items| items.length }]
  elsif i < 0
    return []
  end

  key = [i, a_target, b_target, c_target]
  unless cache.key? key
    a_subsets = []
    if a_target - items[i] >= 0
      a_subsets = subset_sums_of_3(items, i - 1,
                                   a_target - items[i], b_target, c_target,
                                   a_items + [items[i]], b_items, c_items, cache)
    end
    b_subsets = []
    if b_target - items[i] >= 0
      b_subsets = subset_sums_of_3(items, i - 1,
                                   a_target, b_target - items[i], c_target,
                                   a_items, b_items + [items[i]], c_items, cache)
    end
    c_subsets = []
    if c_target - items[i] >= 0
      c_subsets = subset_sums_of_3(items, i - 1,
                                   a_target, b_target, c_target - items[i],
                                   a_items, b_items, c_items + [items[i]], cache)
    end

    cache[key] = a_subsets + b_subsets + c_subsets
  end

  cache[key]
end

# Ref: https://www.techiedelight.com/3-partition-problem/
def partitions_of_3(items)
  total = items.sum
  return [] if total % 3 != 0

  subset_sums_of_3(items, items.length - 1, total / 3, total / 3, total / 3)
end
