#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

def find_unbalanced(program)
  weights = []
  program.subtowers.each do |subprogram|
    weight, adjusted = find_unbalanced(subprogram)
    return nil, adjusted unless adjusted.nil?

    weights << [weight, subprogram]
  end

  tally = weights.map(&:first).tally.sort_by(&:last).map(&:first)
  if tally.length == 2
    program = weights.select { |w, _p| w == tally.first }.first.last
    diff = tally.reverse.inject(&:-)
    [nil, program.weight + diff]
  else
    [program.weight + weights.map(&:first).sum, nil]
  end
end

program_parts = ARGF.each_line.map { |line| line.gsub(/[->(),]/, '').split }

programs = {}
program_parts.each do |parts|
  programs[parts[0]] = Program.new(parts[0], parts[1].to_i)
end

root_programs = programs.dup

program_parts.reject { |p| p.length == 2 }.each do |parts|
  prog = programs[parts[0]]
  parts[2..].each do |subprogram|
    prog.subtowers << root_programs.delete(subprogram)
  end
end

puts find_unbalanced(root_programs.values.first).last
