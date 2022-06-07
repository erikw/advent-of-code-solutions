#!/usr/bin/env ruby

captcha = ARGF.readline.chomp.split('').map(&:to_i)

sum = (0...captcha.length).sum do |i|
  cmp = (i + captcha.length / 2) % captcha.length
  captcha[i] == captcha[cmp] ? captcha[i] : 0
end

puts sum
