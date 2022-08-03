#!/usr/bin/env ruby
# frozen_string_literal: true
# Unresolved concurrency issues currently, TBI (to be investigated)

require_relative '../09/computer'
require 'io/console'

TILE_EMPTY = 0
TILE_WALL = 1
TILE_BLOCK = 2
TILE_HPADDLE = 3
TILE_BALL = 4

SYM = {
  TILE_EMPTY => ' ',
  TILE_WALL => '#',
  TILE_BLOCK => 'B',
  TILE_HPADDLE => '=',
  TILE_BALL => '*'
}

SCORE_POS = -1 + 0i
JOYSTICK_MAP = { 'h' => -1, 'i' => 0, 'l' => 1 }

def display(tiles, score)
  return if tiles.length == 0

  xmin, xmax = tiles.keys.map(&:imag).minmax
  ymin, ymax = tiles.keys.map(&:real).minmax
  puts "===== Score: #{score}"
  (ymin..ymax).each do |y|
    (xmin..xmax).each do |x|
      print SYM[tiles[Complex(x, y)]]
    end
    puts
  end
end

def joystick_pos
  c = nil
  loop do
    c = STDIN.getch
    exit(1) if c == "\u0003"
    break if JOYSTICK_MAP.include?(c)
  end

  JOYSTICK_MAP[c]
end

intcode = File.open(ARGV[0]).readline.split(',').map(&:to_i)
intcode[0] = 2

tiles = Hash.new(TILE_EMPTY) # Coordinate => tile
score = 0
computer = Computer.new
comp_thr = Thread.new { computer.execute(intcode) }

x_ball = 0
x_hpaddle = 0
while comp_thr.alive? || !computer.stdout.empty? || computer.stdin.num_waiting > 0
  if computer.stdin.num_waiting > 0
    # computer.stdin << joystick_pos
    computer.stdin << if x_hpaddle < x_ball
                        1
                      elsif x_hpaddle > x_ball
                        -1
                      else
                        0
                      end
  elsif computer.stdout.length >= 3
    pos = Complex(computer.stdout.pop, computer.stdout.pop)
    val = computer.stdout.pop
    if pos == SCORE_POS
      score = val
    else
      x_ball = pos.real if val == TILE_BALL
      x_hpaddle = pos.real if val == TILE_HPADDLE
      tiles[pos] = val
    end
  end
  display(tiles, score)
end
