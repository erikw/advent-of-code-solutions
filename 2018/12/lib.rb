PATTERN_LEN = 5
POT_EMPTY = '.'
POT_PLANT = '#'

def read_input
  pots = Hash.new(POT_EMPTY)
  ARGF.readline.chomp.split.last.each_char.with_index do |p, i|
    pots[i] = p
  end
  ARGF.readline
  states = Hash.new(POT_EMPTY)
  ARGF.each_line do |line|
    pattern, to = line.chomp.split(' => ')
    states[pattern] = to
  end
  [pots, states]
end

def pots_sum(pots)
  pots.sum { |i, p| p == POT_PLANT ? i : 0 }
end

def next_generation(states, pots)
  pots_next = Marshal.load(Marshal.dump(pots))
  i_min, i_max = pots.keys.minmax

  pot_keys = pots.keys
  pot_keys += (1...PATTERN_LEN).map { |i| i_min - i }
  pot_keys += (1...PATTERN_LEN).map { |i| i_max + i }
  pot_keys.each do |i|
    pattern = (i - 2..i + 2).map { |j| pots[j] }.join
    pots_next[i] = states[pattern]
  end
  pots_next
end
