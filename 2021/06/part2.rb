#!/usr/bin/env ruby
# frozen_string_literal: true

# DAYS_TOTAL = 18
# DAYS_TOTAL = 80
DAYS_TOTAL = 256

def s_que
  que = Queue.new
  gets.split(',').map(&:to_i).each do |fish|
    que << [fish, 0]
  end
  total_fishes = que.length

  until que.empty?
    fish, spawn_day = que.pop
    day = spawn_day + fish + 1
    until day > DAYS_TOTAL
      que << [8, day]
      total_fishes += 1
      day += 7
    end
  end

  puts total_fishes
end

def s_count
  fishes = Array.new(9, 0)
  gets.split(',').map(&:to_i).each do |fish|
    fishes[fish] += 1
  end

  (0...DAYS_TOTAL).each do |day|
    fishes[(day + 7) % 9] += fishes[day % 9]
  end
  puts fishes.sum
end

# s_que
s_count
