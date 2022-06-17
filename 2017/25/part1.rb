#!/usr/bin/env ruby

state = ARGF.readline.chomp.split.last.delete('.')
check_steps = ARGF.readline.chomp.split[-2].to_i

fsm = {}
until ARGF.eof?
  ARGF.readline
  in_state = ARGF.readline.chomp.split.last.delete(':')
  state_values = Array.new(2)
  2.times.map do
    cur_value = ARGF.readline.chomp.split.last.to_i
    write = ARGF.readline.chomp.split.last.to_i
    move = ARGF.readline.chomp.split.last.delete('.') == 'right' ? 1 : -1
    next_state = ARGF.readline.chomp.split.last.delete('.')

    state_values[cur_value] = [write, move, next_state]
  end
  fsm[in_state] = state_values
end

tape = Hash.new(0)
cursor = 0
check_steps.times do
  write, move, next_state = fsm[state][tape[cursor]]
  tape[cursor] = write
  cursor += move
  state = next_state
end

puts tape.values.sum
