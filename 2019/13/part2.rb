#!/usr/bin/env ruby

require_relative '../09/computer_iter'

TILE_EMPTY = 0
TILE_WALL = 1
TILE_BLOCK = 2
TILE_HPADDLE = 3
TILE_BALL = 4

SCORE_POS = -1 + 0i
ANSI_CLEAR_SCREEN = "\033c"

SYM = {
  TILE_EMPTY => ' ',
  TILE_WALL => '#',
  TILE_BLOCK => 'B',
  TILE_HPADDLE => '=',
  TILE_BALL => '*'
}

def display(tiles, score)
  return if tiles.length == 0

  puts ANSI_CLEAR_SCREEN
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

def joystick_pos_ai(x_ball, x_hpaddle)
  return 0 if x_ball == x_hpaddle

  x_ball < x_hpaddle ? -1 : 1
end

intcode = File.open(ARGV[0]).readline.split(',').map(&:to_i)
intcode[0] = 2

tiles = Hash.new(TILE_EMPTY) # Coordinate => tile
score = 0
computer = Computer.new(intcode)

x_ball = 0
x_hpaddle = 0
status = nil
until status == Computer::STATUS_DONE
  status = computer.execute
  case status
  when Computer::STATUS_INPUT_NEEDED
    computer.stdin << joystick_pos_ai(x_ball, x_hpaddle)
  when Computer::STATUS_OUTPUT
    if computer.stdout.length >= 3
      pos = Complex(computer.stdout.pop, computer.stdout.pop)
      val = computer.stdout.pop
      if pos == SCORE_POS
        score = val
        # display(tiles, score)
      else
        x_ball = pos.real if val == TILE_BALL
        x_hpaddle = pos.real if val == TILE_HPADDLE
        tiles[pos] = val
      end
    end
  end
end
# display(tiles, score)
puts score
