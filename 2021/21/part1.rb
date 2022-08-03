#!/usr/bin/env ruby
# frozen_string_literal: true

END_SCORE = 1000

def turn(pos, score, die, player)
  pos = (pos + 3 * die + 6 - 1) % 10 + 1
  puts "Player #{player} rolls #{die + 1}+#{die + 2}+#{die + 3} and moves to space #{pos} for a total score of #{score + pos}."
  [pos, score + pos, die + 3]
end

p1_pos, p2_pos = ARGF.each_line.map { |line| line.split.last.to_i }
p1_score = 0
p2_score = 0
die = 0

loop  do
  p1_pos, p1_score, die = turn(p1_pos, p1_score, die, 1)
  break if p1_score >= END_SCORE

  p2_pos, p2_score, die = turn(p2_pos, p2_score, die, 2)
  break if p2_score >= END_SCORE
end

puts '=' * 20
puts "END player 1 has score #{p1_score} at postion #{p1_pos}"
puts "END player 2 has score #{p2_score} at postion #{p2_pos}"
if p1_score >= END_SCORE
  puts 'Player 1 won '
else
  puts 'Player 2 won'
end

lose_score = p1_score < END_SCORE ? p1_score : p2_score
puts "Losing score: #{lose_score}"
puts "Rolls: #{die}"
puts lose_score * die
