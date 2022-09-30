#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'computer_iter'

program = ARGF.readlines.map { |l| l.chomp.split }
computer = Computer.new

instr_old = nil
program.length.times do |i|
  next if program[i][0] == 'acc'

  program[i][0], instr_old = program[i][0] == 'jmp' ? %w[nop jmp] : %w[jmp nop]
  status = computer.execute(program)

  if status == Computer::STATUS_DONE
    puts computer.memory[:acc]
    break
  end

  program[i][0] = instr_old
end
