#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

# MOVES = 10
MOVES = 100

DEBUG = false

class Node
  attr_accessor :prev, :next
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def to_s
    "Node(#{@value})"
  end
end

def debug(message)
  puts message if DEBUG
end

def cups_string(node_start)
  cur = node_start
  values = []
  loop do
    values << cur.value
    cur = cur.next

    break if cur == node_start
  end
  values.join(' ')
end

def print_cups(node_start)
  debug cups_string(node_start)
end

first = nil
cur = nil
val_max = 0
val_min = Float::INFINITY
ARGF.readline.chomp.split('').map(&:to_i).each do |num|
  val_max = [num, val_max].max
  val_min = [num, val_min].min

  node = Node.new(num)
  if first.nil?
    first = node
  else
    cur.next = node
    node.prev = cur
  end
  cur = node
end
cur.next = first
first.prev = cur

cur = first

MOVES.times do |i|
  debug "-- move #{i + 1} --"
  pick_first = cur.next
  pick_last = cur.next.next.next

  pick_values = [pick_first.value, pick_first.next.value, pick_last.value]
  debug "cups: #{cups_string(cur)}"
  debug "cur: #{cur.value}"
  debug "pickup: #{pick_values.join(' ')}"

  cur.next = pick_last.next
  pick_last.prev = cur

  pick_first.prev = nil
  pick_last.next = nil

  debug "cups reduced: #{cups_string(cur)}"

  val_next = cur.value - 1

  dest = cur.next
  loop do
    debug "DestSearch: #{val_next}"
    dest = dest.next until dest.value == val_next || dest == cur
    break if dest.value == val_next

    val_next -= 1
    val_next = val_max if val_next < val_min
    dest = cur.next
  end

  debug "destination: #{dest.value}\n\n"

  pick_last.next = dest.next
  dest.next.prev = pick_last
  pick_first.prev = dest
  dest.next = pick_first

  cur = cur.next
end

cur = cur.next until cur.value == 1

values = []
itr = cur.next
until itr == cur
  values << itr.value
  itr = itr.next
end

puts values.join
