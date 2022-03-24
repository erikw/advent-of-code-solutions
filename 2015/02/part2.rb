#!/usr/bin/env ruby

ribbon = ARGF.each_line.map { |l| l.split('x').map(&:to_i) }.map do |l, w, h|
  lw = 2 * l + 2 * w
  wh = 2 * w + 2 * h
  hl = 2 * h + 2 * l
  [lw, wh, hl].min + l * w * h
end.sum
puts ribbon
