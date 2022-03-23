#!/usr/bin/env ruby

END_SCORE = 21

def play(cache, positions, scores, player, cur_roll, die_value_next)
  cache_key = [positions, scores, player, cur_roll, die_value_next].hash
  return cache[cache_key] if cache.include?(cache_key)

  player_other = (player + 1) % 2
  positions[player] = (positions[player] + die_value_next - 1) % 10 + 1
  if cur_roll == 3
    scores[player] += positions[player]
    if scores[player] >= END_SCORE
      return player == 0 ? [1, 0] : [0, 1]
    else
      player = player_other
      cur_roll = 0
    end
  end
  p1_wins1, p2_wins1 = play(cache, positions.dup, scores.dup, player, cur_roll + 1, 1)
  p1_wins2, p2_wins2 = play(cache, positions.dup, scores.dup, player, cur_roll + 1, 2)
  p1_wins3, p2_wins2 = play(cache, positions.dup, scores.dup, player, cur_roll + 1, 3)
  cache[cache_key] = [p1_wins1 + p1_wins2 + p1_wins3, p1_wins1 + p1_wins2 + p1_wins3]
end

positions = ARGF.each_line.map { |line| line.split.last.to_i }
scores = [0, 0]
cache = {}

p1_wins1, p2_wins1 = play(cache, positions.dup, scores.dup, 0, 1, 1)
p1_wins2, p2_wins2 = play(cache, positions.dup, scores.dup, 0, 1, 2)
p1_wins3, p2_wins3 = play(cache, positions.dup, scores.dup, 0, 1, 3)

puts [p1_wins1 + p1_wins2 + p1_wins3, p1_wins1 + p1_wins2 + p1_wins3].max
