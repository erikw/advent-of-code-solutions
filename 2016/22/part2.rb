#!/usr/bin/env ruby

class Node
  attr_reader :x, :y, :size, :used
  attr_accessor :blocked

  def initialize(_x, y, size, used)
    @x = y
    @y = y
    @size = size
    @used = used
    @blocked = false
  end
end

2.times { ARGF.readline }

DISK_PATTERN = %r{/dev/grid/node-x(?<x>\d+)-y(?<y>\d+)\s+(?<size>\d+)T\s+(?<used>\d+)T\s+(?<avail>\d+)T\s+\d+%}
nodes = [[]]
cur_x = 0
ARGF.each_line do |line|
  match = line.match(DISK_PATTERN)
  x = match['x'].to_i
  y = match['y'].to_i
  size = match['size'].to_i
  used = match['used'].to_i
  node = Node.new(x, y, size, used)
  if x != cur_x
    nodes << []
    cur_x  = x
  end
  nodes.last << node
end

nodes = nodes.transpose

def blocked(nodes, row_from, col_from, row_to, col_to)
  if row_to.between?(0, nodes.length - 1) && col_to.between?(0, nodes[0].length - 1)
    node_from = nodes[row_from][col_from]
    node_to = nodes[row_to][col_to]
    node_from.used > node_to.size
  else
    true
  end
end

(0...nodes.length).each do |row|
  (0...nodes[0].length).each do |col|
    next unless blocked(nodes, row, col, row - 1, col) &&
                blocked(nodes, row, col, row + 1, col) &&
                blocked(nodes, row, col, row, col - 1) &&
                blocked(nodes, row, col, row, col + 1)

    nodes[row][col].blocked = true
  end
end

nodes.each do |row|
  rep = row.map do |node|
    if node.blocked
      '|'
    elsif node.used == 0
      '_'
    else
      "#{node.used}/#{node.size}"
    end.rjust(7)
  end.join(' ')
  puts rep
end

# With our eyes we can now easilty deduct that
# 62 steps to take us to
# ... _ G |
# 6 * 35 steps to take us to
# | _ G ...
# 1 step to take us to the final
# | G _ ...
#
puts '=' * 16
puts 62 + 5 * 35 + 1
