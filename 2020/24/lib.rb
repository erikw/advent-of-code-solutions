# frozen_string_literal: true

TILE_WHITE = false
TILE_BLACK = true

def parse_directions(string, &block)
  string.chomp.scan(/se|sw|nw|ne|e|w/, &block)
end

def track_path(_tiles, directions)
  # Switch to Cube coordinates (pointy view).
  # Lesson learned from 2017/11!
  # Ref: https://www.redblobgames.com/grids/hexagons/#coordinates-cube
  r = 0
  s = 0
  q = 0

  directions.each do |dir|
    case dir
    when 'e'
      q += 1
      s -= 1
    when 'se'
      r += 1
      s -= 1
    when 'sw'
      r += 1
      q -= 1
    when 'w'
      s += 1
      q -= 1
    when 'nw'
      s += 1
      r -= 1
    when 'ne'
      q += 1
      r -= 1
    end
  end
  [r, s, q]
end
