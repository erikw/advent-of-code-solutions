#!/usr/bin/env ruby

require_relative 'lib'

program_parts = ARGF.each_line.map { |line| line.gsub(/[->(),]/, '').split }

programs = {}
program_parts.each do |parts|
  programs[parts[0]] = Program.new(parts[0], parts[1].to_i)
end

# pp programs
root_programs = programs.dup

program_parts.reject { |p| p.length == 2 }.each do |parts|
  prog = programs[parts[0]]
  parts[2..].each do |subprogram|
    prog.subtowers << root_programs.delete(subprogram)
  end
end

puts root_programs.keys
