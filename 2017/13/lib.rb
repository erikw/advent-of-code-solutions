# frozen_string_literal: true

def scanner_pos(range, time)
  time %= 2 * range - 2
  if time >= range
    2 * range - time - 2
  else
    time
  end
end

def severeties(layers, wait = 0)
  layers.map do |depth, range|
    depth * range if scanner_pos(range, depth + wait) == 0
  end.compact
end
