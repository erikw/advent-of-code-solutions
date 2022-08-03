#!/usr/bin/env ruby
# frozen_string_literal: true

ITERATIONS = 10

class Node
  attr_reader :value
  attr_accessor :next

  def initialize(value, next_node = nil)
    @value = value
    @next = next_node
  end

  def to_s
    @value.to_s
  end
  alias inspect to_s
end

def print_list(head)
  out = ''
  until head.nil?
    out += "#{head} -> "
    head = head.next
  end
  puts out
end

head = nil
cur = nil
ARGF.readline.chomp.each_char do |c|
  node = Node.new(c)
  if head.nil?
    head = node
    cur = head
  else
    cur.next = node
    cur = node
  end
end
ARGF.readline

# print_list(head)

rules = {}
ARGF.each_line do |line|
  lhs, rhs = line.chomp.split(' -> ')
  rules[lhs] = rhs
end

# pp rules

ITERATIONS.times do
  node = head
  until node.nil?
    break if node.next.nil?

    from = node.value + node.next.value
    prod = rules.fetch(from, nil)
    unless prod.nil?
      prod_node = Node.new(prod, node.next)
      node.next = prod_node
      node = node.next
    end
    node = node.next
  end
end

# print_list(head)

freq = Hash.new(0)
node = head
until node.nil?
  freq[node.value] += 1
  node = node.next
end

puts freq.minmax_by { |_k, v| v }.map(&:last).sort.reverse.inject(&:-)
