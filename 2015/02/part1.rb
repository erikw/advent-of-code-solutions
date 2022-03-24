#!/usr/bin/env ruby

paper = ARGF.each_line.map { |l| l.split('x').map(&:to_i) }.map do |l, w, h|
  lw = l * w
  wh = w * h
  hl = h * l
  2 * lw + 2 * wh + 2 * hl + [lw, wh, hl].min
end.sum
puts paper
