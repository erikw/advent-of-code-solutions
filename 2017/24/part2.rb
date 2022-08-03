#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

require_relative 'lib'

def longest_bridge(ports, last_port = 0)
  longest_bridge = []
  unless ports[last_port].empty?
    longest_strengh = 0
    ports[last_port].dup.each do |match_comp|
      other_port = match_comp.port1 == last_port ? match_comp.port2 : match_comp.port1

      ports[match_comp.port1].delete(match_comp)
      ports[match_comp.port2].delete(match_comp)
      bridge = longest_bridge(ports, other_port).unshift(match_comp)
      ports[match_comp.port1] << match_comp
      ports[match_comp.port2] << match_comp

      strength = bridge_strength(bridge)
      next unless bridge.length > longest_bridge.length ||
                  bridge.length == longest_bridge.length && strength > longest_strengh

      longest_bridge = bridge
      longest_strengh = strength
    end
  end
  longest_bridge
end

ports = Hash.new { |h, k| h[k] = Set.new }
ARGF.each_line.map do |line|
  component = Component.new(*line.chomp.split('/').map(&:to_i))
  ports[component.port1] << component
  ports[component.port2] << component
end

puts bridge_strength(longest_bridge(ports))
