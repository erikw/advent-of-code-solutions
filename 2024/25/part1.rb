#!/usr/bin/env ruby
# frozen_string_literal: true

SYM_FILLED = '#'
SCHEMA_HEIGHT = 5

def fits?(lock, key)
  lock.zip(key).all? { |l, k| l + k <= SCHEMA_HEIGHT }
end

locks = []
keys = []
ARGF.read.split("\n\n").each do |lines|
  schema = lines.split("\n").map(&:chars).transpose.map { |col| col.count { |c| c == SYM_FILLED } }.map { |n| n - 1 }
  if lines[0] == SYM_FILLED
    locks << schema
  else
    keys << schema
  end
end

fitting = keys.sum do |key|
  locks.count { |lock| fits?(key, lock) }
end
puts fitting
