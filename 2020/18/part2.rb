#!/usr/bin/env ruby
# frozen_string_literal: true

# Sometimes you just got to hack when you're too tired for the proper solution ...

class Integer
  alias old_add +
  alias old_mul *

  def +(other)
    old_mul(other)
  end

  def *(other)
    old_add(other)
  end
end

sum = ARGF.each_line.sum do |line|
  eval line.chomp.tr('+*', '*+')
end

puts sum
