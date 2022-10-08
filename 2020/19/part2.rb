#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

CHAR_OR = '|'

# Merge of part1 solution + caching + https://www.reddit.com/r/adventofcode/comments/kg1mro/comment/ggcj4fm/
def valid(rules, message, rule = '0', pos = 0, cache = {})
  cache_key = [rule, pos]
  unless cache.has_key?(cache_key)
    if pos >= message.length
      cache[cache_key] = Set.new
    elsif rules[rule].length == 1 && rules[rule][0].length == 1 && rules[rule][0] !~ /\d+/
      cache[cache_key] = if message[pos] == rules[rule][0][0]
                           Set[pos + 1]
                         else
                           Set.new
                         end
    else
      poss = Set.new # All end+1 positions
      rules[rule].each do |rule_alt|
        poss_alts = Set[pos]
        rule_alt.each do |rule_elem|
          poss_alts_next = Set.new
          poss_alts.each do |pos_alt|
            poss_alts_next |= valid(rules, message, rule_elem, pos_alt, cache)
          end
          poss_alts = poss_alts_next
        end
        poss |= poss_alts
      end
      cache[cache_key] = poss
    end
  end

  if rule == '0'
    cache[cache_key].include?(message.length)
  else
    cache[cache_key]
  end
end

in_rules, in_messages = ARGF.readlines.join.split("\n\n")

rules = {} # rule_nbr -> [[x, y], [z, w]] rule alternations
in_rules.each_line do |rule_str|
  nbr, rule = rule_str.chomp.split(': ')
  if nbr == '8'
    rule = '42 | 42 8'
  elsif nbr == '11'
    rule = '42 31 | 42 11 31'
  end

  rules[nbr] = rule.split(CHAR_OR).map { |p| p.split(' ').map { |e| e.tr('""', '') } }
end

num_valid = in_messages.each_line.count do |message|
  valid(rules, message.chomp)
end

puts num_valid
