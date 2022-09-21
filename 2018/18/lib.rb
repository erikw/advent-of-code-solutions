SYM_OPEN = '.'
SYM_TREES = '|'
SYM_LUMBER = '#'

def neighbours_count(acres, x, y)
  counts = Hash.new(0)
  [-1, 0, 1].each do |dx|
    [-1, 0, 1].each do |dy|
      xn = x + dx
      yn = y + dy
      next if dx == 0 && dy == 0 || !xn.between?(0, acres.length - 1) || !yn.between?(0, acres.length - 1)

      counts[acres[xn][yn]] += 1
    end
  end
  counts
end

def acre_next(acres, x, y)
  neighbours = neighbours_count(acres, x, y)
  case acres[x][y]
  when SYM_OPEN
    neighbours[SYM_TREES] >= 3 ? SYM_TREES : SYM_OPEN
  when SYM_TREES
    neighbours[SYM_LUMBER] >= 3 ? SYM_LUMBER : SYM_TREES
  when SYM_LUMBER
    neighbours[SYM_LUMBER] >= 1 && neighbours[SYM_TREES] >= 1 ? SYM_LUMBER : SYM_OPEN
  end
end

def iterate_acres(acres)
  acres_next = Marshal.load(Marshal.dump(acres))
  (0...acres.length).each do |x|
    (0...acres[0].length).each do |y|
      acres_next[x][y] = acre_next(acres, x, y)
    end
  end

  acres = acres_next
end
