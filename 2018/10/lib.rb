# frozen_string_literal: true

CHAR_HEIGHT = 6

def print_message(points)
  row_points = points.group_by { |p| p[0][1] }
  x_min, x_max = points.minmax_by { |p| p[0][0] }.map(&:first).map(&:first)
  y_min, y_max = points.minmax_by { |p| p[0][1] }.map(&:first).map(&:last)

  rows = (y_min..y_max).map do |y|
    (x_min..x_max).map do |x|
      row_points&.[](y).any? { |p| p[0][0] == x } ? '#' : ' '
    end.join
  end
  puts rows.join("\n")
end

def search_message(points_input)
  points = Marshal.load(Marshal.dump(points_input))
  seconds = 0
  loop do
    col_points = points.group_by { |p| p[0][0] }
    break if col_points.any? do |_, pnts|
      pnts.map { |p| p[0][1] }.sort.each_cons(CHAR_HEIGHT).any? do |ys|
        ys.each_cons(2).all? { |y1, y2| y2 - y1 == 1 }
      end
    end

    points.each do |point|
      point[0][0] += point[1][0]
      point[0][1] += point[1][1]
    end
    seconds += 1
  end
  [points, seconds]
end
