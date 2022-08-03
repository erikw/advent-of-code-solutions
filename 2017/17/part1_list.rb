#!/usr/bin/env ruby
# frozen_string_literal: true

VALUES = 2018

class Node
  attr_reader :value
  attr_accessor :next

  def initialize(value = 0, nextn = nil)
    @value = value
    @next = nextn
  end
end

steps = ARGF.readline.to_i

node = Node.new
node.next = node

(1...VALUES).each do |v|
  steps.times do
    node = node.next
  end
  node_new = Node.new(v)
  node_new.next = node.next
  node.next = node_new
  node = node_new
end

puts node.next.value
