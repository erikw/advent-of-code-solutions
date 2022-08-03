#!/usr/bin/env ruby
# frozen_string_literal: true

class Reindeer
  attr_reader :name, :speed, :fly, :rest
  attr_accessor :state, :until, :distance, :points

  def initialize(name, speed, fly, rest)
    @name = name
    @speed = speed
    @fly = fly
    @rest = rest
    @state = :flying
    @until = fly - 1
    @distance = 0
    @points = 0
  end
end

r = %r{(\w+) (?:\w+ ){2}(\d+) km/s for (\d+) (?:[\w,]+ ){6}(\d+)}
reindeers = []
ARGF.each_line do |line|
  m = line.match(r)
  reindeers << Reindeer.new(m[1], m[2].to_i, m[3].to_i, m[4].to_i)
end

time = 0
until time == 2504
  reindeers.each do |reindeer|
    if reindeer.state == :flying
      if reindeer.until == time
        reindeer.state = :resting
        reindeer.until = time + reindeer.rest
        reindeer.distance += reindeer.speed
      else
        reindeer.distance += reindeer.speed
      end
    elsif reindeer.until == time
      reindeer.state = :flying
      reindeer.until = time + reindeer.fly
    end
  end
  time += 1

  reindeers.group_by(&:distance).max.last.each do |r|
    r.points += 1
  end
end

puts reindeers.map(&:points).max
