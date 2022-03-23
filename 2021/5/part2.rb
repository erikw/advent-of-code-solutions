#!/usr/bin/env ruby

require_relative 'point'

point_counts = Hash.new(0)
ARGF.each_line.map { |line| line.chomp.split(/ -> |,/).map(&:to_i) }.each do |x_col, x_row, y_col, y_row|
  if x_col == y_col
    r_start, r_end = [x_row, y_row].sort
    (r_start..r_end).each do |row|
      point = Point.new(x_col, row)
      point_counts[point] += 1
    end
  elsif x_row == y_row
    c_start, c_end = [x_col, y_col].sort
    (c_start..c_end).each do |col|
      point = Point.new(col, x_row)
      point_counts[point] += 1
    end
  else
    col = x_col
    row = x_row
    col_asc = x_col < y_col
    row_asc = x_row < y_row
    until col == (col_asc ? y_col + 1 : y_col - 1)
      point = Point.new(col, row)
      point_counts[point] += 1
      col += col_asc ? 1 : -1
      row += row_asc ? 1 : -1
    end
  end
end

puts point_counts.count { |_point, count| count >= 2 }
