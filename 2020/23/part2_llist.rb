#!/usr/bin/env ruby
# frozen_string_literal: true

# Too slow!

require 'set'

MOVES = 10_000_000
CUPS = 1_000_000

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

((val_max + 1)...CUPS).each do |num|
  val_max = [num, val_max].max
  val_min = [num, val_min].min

  node = Node.new(num)
  cur.next = node
  node.prev = cur
  cur = node
end

cur.next = first
first.prev = cur

cur = first

MOVES.times do |i|
  puts "Move #{i + 1}" if ((i + 1) % 100) == 0
  pick_first = cur.next
  pick_last = cur.next.next.next

  pick_values = [pick_first.value, pick_first.next.value, pick_last.value]

  cur.next = pick_last.next
  pick_last.prev = cur

  pick_first.prev = nil
  pick_last.next = nil

  val_next = cur.value - 1

  dest = cur.next
  loop do
    dest = dest.next until dest.value == val_next || dest == cur
    break if dest.value == val_next

    val_next -= 1
    val_next = val_max if val_next < val_min
    dest = cur.next
  end

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
