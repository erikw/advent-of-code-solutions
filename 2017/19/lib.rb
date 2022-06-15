ANSI_CLEAR_SCREEN = "\033c"
ANSI_RED = "\033[31;1m"
ANSI_CLEAR = "\033[0m"

def print_location(diagram, row, col)
  print ANSI_CLEAR_SCREEN
  diagram_cpy = Marshal.load(Marshal.dump(diagram))
  # diagram_cpy[row][col] = '😀'
  diagram_cpy[row][col] = "#{ANSI_RED}*#{ANSI_CLEAR}"
  diagram_cpy.each do |row|
    puts row
  end
end

JUNCTIONS = {
  south: [[0, -1, :west], [0, 1, :east], [1, 0]],
  north: [[0, -1, :west], [0, 1, :east], [-1, 0]],
  east: [[-1, 0, :north], [1, 0, :south], [0, 1]],
  west: [[-1, 0, :north], [1, 0, :south], [0, -1]]
}

STEPS = {
  south: [1, 0],
  north: [-1, 0],
  east: [0, 1],
  west: [0, -1]
}

def traverse_routing(diagram, print_progress = false)
  row = 0
  col = diagram[0].index('|')
  direction = :south
  collected = []
  steps = 0
  while row.between?(0, diagram.length - 1) &&
        col.between?(0, diagram[0].length - 1) &&
        diagram[row][col] != ' '

    if print_progress
      sleep(0.15)
      print_location(diagram, row, col)
    end

    collected << diagram[row][col] if diagram[row][col].match?(/[A-Z]/)
    if diagram[row][col] == '+'
      ndir = if diagram[row + JUNCTIONS[direction][0][0]][col + JUNCTIONS[direction][0][1]] != ' '
               0
             else
               1
             end
      row += JUNCTIONS[direction][ndir][0]
      col += JUNCTIONS[direction][ndir][1]
      direction = JUNCTIONS[direction][ndir][2]
    else
      row += STEPS[direction][0]
      col += STEPS[direction][1]
    end
    steps += 1
  end
  [collected, steps]
end
