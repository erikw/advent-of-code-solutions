#!/usr/bin/env ruby

CHIP_LO = 17
CHIP_HI = 61
R_BOT = /bot (\d+) gives low to (\w+ \d+) and high to (\w+ \d+)/
R_VALUE = /value (\d+) goes to bot (\d+)/

bots = Hash.new { |h, k| h[k] = [[nil, nil], []] } # [[[type,low], [type, high]], [values]]
outputs = Hash.new { |h, k| h[k] = [] }
ARGF.each_line do |line|
  if line.start_with?('bot')
    m = R_BOT.match(line)
    bots[m[1]][0] = [m[2].split, m[3].split]
  else
    m = R_VALUE.match(line)
    bots[m[2]][1] << m[1].to_i
  end
end

loop do
  chip_lo_bot = bots.select { |_num, bot| bot[1].include?(CHIP_LO) }.map(&:first).first
  chip_hi_bot = bots.select { |_num, bot| bot[1].include?(CHIP_HI) }.map(&:first).first

  full = bots.select { |_num, bot| bot[1].length == 2 }
  break if full.empty?

  full.each do |num, bot|
    chips = bot[1].sort
    update = lambda do |type, num, value|
      if type == 'bot'
        bots[num][1] << value
      else
        outputs[num] << value
      end
    end
    update.call(bot[0][0][0], bot[0][0][1], chips[0])
    update.call(bot[0][1][0], bot[0][1][1], chips[1])
    bots[num][1].clear
  end
end

puts %w[0 1 2].map { |n| outputs[n].first }.inject(&:*)
