# frozen_string_literal: true

def nth_spoken(nums_start, _nth)
  turn = 0
  num_last = nil
  seen = {} # number -> turn_last_seen

  nums_start.each do |num_start|
    seen[num_last] = turn unless num_last.nil?
    turn += 1
    num_last = num_start
  end

  while turn < NTH_NUMBER
    # num_next = if seen.include?(num_last)
    #             turn - seen[num_last]
    #           else
    #             0
    #           end
    # ... or simply:
    num_next = turn - seen.fetch(num_last, turn)

    seen[num_last] = turn
    turn += 1
    num_last = num_next
  end

  num_last
end
