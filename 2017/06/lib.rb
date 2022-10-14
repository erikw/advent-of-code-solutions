# frozen_string_literal: true

def largest_bank(banks)
  banks.index(banks.max)
end

def realloc(banks)
  largest = largest_bank(banks)
  blocks = banks[largest]
  banks[largest] = 0

  i = (largest + 1) % banks.length
  blocks.times do
    banks[i] += 1
    i = (i + 1) % banks.length
  end
end
