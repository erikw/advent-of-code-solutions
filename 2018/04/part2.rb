#!/usr/bin/env ruby
# frozen_string_literal: true

require 'time'

guard_id = nil
sleep_start = nil

guard_sleeps = Hash.new { |h, k| h[k] = Array.new(60, 0) }
ARGF.each_line.map do |line|
  time, event = line.split(']')
  time = Time.parse(time[1..])
  event.strip!
  [time, event]
end.sort_by(&:first).each do |time, event|
  case event
  when /Guard #(\d+) begins shift/
    guard_id = Regexp.last_match(1).to_i
  when 'falls asleep'
    sleep_start = time.min
  when 'wakes up'
    (sleep_start...time.min).each do |min|
      guard_sleeps[guard_id][min] += 1
    end
  end
end

ans = guard_sleeps.map do |guard_id, minutes|
  days, most_minute = minutes.each_with_index.max_by(&:first)
  [days, most_minute, guard_id]
end.max_by(&:first).drop(1).inject(&:*)
puts ans
