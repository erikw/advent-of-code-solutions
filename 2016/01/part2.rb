#!/usr/bin/env ruby

row = 0
col = 0
facing = 0
lines = []
ARGF.readline.split(', ').map {|p| [p[0], p[1..].to_i] }.each do |turn, dist|
  facing = (facing + (turn == 'R' ? 1 : -1)) % 4
  rstart, cstart = row, col
  case facing
  when 0 then row += dist.to_i  # N
  when 1 then col += dist.to_i  # E
  when 2 then row -= dist.to_i  # S
  when 3 then col -= dist.to_i  # W
  end

  line_new = [[rstart, cstart], [row, col]]
  line_new_horiz = line_new[0][0] == line_new[1][0]
  lines[0...-1].each do |line|
    line_horiz = line[0][0] == line[1][0]
    if line_new_horiz && line_horiz
      ls = lines[0][1]
      le = lines[1][1]
      lns = lines_new[0][1]
      lne = lines_new[1][1]
      if ls.between?(lns, lne) || le.between?(lns, lne) || lns.between?(ls, le) || lne.between?(ls, le)
        puts # TODO calc instersection point
        return true
      end
    end

  end


  lines << line_new
end
