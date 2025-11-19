#!/usr/bin/env ruby
# frozen_string_literal: true

def op(wires, in1, op, in2)
  v1 = wires[in1]
  v2 = wires[in2]
  case op
  when 'AND' then v1 & v2
  when 'OR' then v1 | v2
  when 'XOR' then v1 ^ v2
  end
end

in_wires, in_gates = ARGF.read.split("\n\n")

wires = in_wires.each_line.map do |line|
  n, v = line.chomp.split(': ')
  [n, v.to_i]
end.to_h

# [in1, OP, in2, out]
gates = in_gates.each_line.map { |l| l.chomp.split(/ -> | /) }

wires_final = gates.map(&:last).select { |g| g[0] == 'z' }.sort.reverse

# Make sure all wires are in wires, not only the ones with initial value.
gate_wires = gates.flat_map { |in1, _op, in2, out| [in1, in2, out] }.to_set
gate_wires.each do |wire|
  wires[wire] = nil unless wires.key?(wire)
end

# until wires_final.all? { |wire| !wires[wire].nil? }
#  gates.each do |in1, op, in2, out|
#    wires[out] = op(wires, in1, op, in2) if !wires[in1].nil? && !wires[in2].nil?
#  end
# end

pending = gates.dup
until pending.empty?
  pending.delete_if do |in1, op, in2, out|
    v1 = wires[in1]
    v2 = wires[in2]
    next false if v1.nil? || v2.nil?

    wires[out] = op(wires, in1, op, in2)
    true
  end
end

num = wires_final.map { |w| wires[w] }.join.to_i(2)
puts num
