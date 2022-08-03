#!/usr/bin/env ruby
# frozen_string_literal: true

def bingo(board, row, col)
  board[row].all?(&:negative?) || board.transpose[col].all?(&:negative?)
end

def game(boards, draw_nbrs)
  draw_idx = -1
  while draw_idx < draw_nbrs.length
    draw_idx += 1
    boards.each do |board|
      (0...board.length).each do |row|
        (0...board[row].length).each do |col|
          if board[row][col] == draw_nbrs[draw_idx]
            board[row][col] *= -1
            return [draw_nbrs[draw_idx], board] if bingo(board, row, col)
          end
        end
      end
    end
  end
  nil
end

draw_nbrs = ARGF.readline.split(',').map(&:to_i)
ARGF.readline

boards = []
cur_board = []

ARGF.each_line.map(&:chomp).each do |line|
  if line.empty?
    boards << cur_board
    cur_board = []
  else
    cur_board << line.split.map(&:to_i)
  end
end
boards << cur_board

draw_nbr, winning_board = game(boards, draw_nbrs)

unmarked_sum = winning_board.map do |row|
  row.reject(&:negative?).sum
end.sum
puts draw_nbr * unmarked_sum
