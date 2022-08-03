#!/usr/bin/env ruby
# frozen_string_literal: true

# CHIP_LO = 2
# CHIP_HI = 5
CHIP_LO = 17
CHIP_HI = 61
R_BOT = /bot (?<bot_num>\d+)[\w ]+? (?<lo_type>\w+) (?<lo_num>\d+)[\w ]+? (?<hi_type>\w+) (?<hi_num>\d+)/
R_VALUE = /[\w ]+ (?<value>\d+)[\w ]+ (?<bot_num>\d+)$/

class Bot
  def initialize(num)
    @num = num
    @lo_to = nil
    @hi_to = nil
    @values = []
  end

  def set_tos(lo, hi)
    @lo_to = lo
    @hi_to = hi
    chk
  end

  def recv(val)
    @values << val
    chk
  end

  private

  def chk
    if @values.length == 2
      @values.sort!
      if @values == [CHIP_LO, CHIP_HI]
        puts @num
        exit
      end
      unless @lo_to.nil? || @hi_to.nil?
        @lo_to.recv(@values.shift)
        @hi_to.recv(@values.shift)
      end
    end
  end
end

class Output
  def initialize(num)
    @num = num
    @values = []
  end

  def recv(val)
    @values << val
  end

  def to_s
    "output{num=#{@num}, values=#{@values}}"
  end
  alias inspect to_s
end

bots = Hash.new { |h, k| h[k] = Bot.new(k) }
outputs = Hash.new { |h, k| h[k] = Output.new(k) }

ARGF.each_line do |cmd|
  if cmd.start_with?('bot')
    m = R_BOT.match(cmd)
    dest_lo = m['lo_type'] == 'bot' ? bots : outputs
    dest_hi = m['hi_type'] == 'bot' ? bots : outputs
    bots[m['bot_num']].set_tos(dest_lo[m['lo_num']], dest_hi[m['hi_num']])
  else
    m = R_VALUE.match(cmd)
    bots[m['bot_num']].recv(m['value'].to_i)
  end
end

# bots.each do |num, bot|
# puts num if bot.values.sort == [CHIP_LO, CHIP_HI]
# end
