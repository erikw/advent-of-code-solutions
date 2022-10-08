#!/usr/bin/env ruby
# frozen_string_literal: true

CHAR_OR = '|'

def valid(rules, message, rule = '0', pos = 0)
  pos_alt = nil
  full_match = rules[rule].any? do |rule_alt|
    pos_alt = pos
    rule_alt.all? do |rule_elem|
      if rule_elem.match(/\d+/)
        valid_rec, pos_alt = valid(rules, message, rule_elem, pos_alt)
        valid_rec
      else
        v = message[pos_alt] == rule_elem
        pos_alt += 1
        v
      end
    end
  end
  if rule == '0'
    [full_match && pos_alt == message.length, pos_alt]
  else
    [full_match, pos_alt]
  end
end

in_rules, in_messages = ARGF.readlines.join.split("\n\n")

rules = {} # rule_nbr -> [[x, y], [z, w]] rule alternations
in_rules.each_line do |rule_str|
  nbr, rule = rule_str.chomp.split(': ')
  rules[nbr] = rule.split(CHAR_OR).map { |p| p.split(' ').map { |e| e.tr('""', '') } }
end

num_valid = in_messages.each_line.count do |message|
  valid(rules, message.chomp)[0]
end

puts num_valid
