#!/usr/bin/env ruby

WIN_LEN = 4

tls = ARGF.each_line.map(&:chomp).count do |line|
  hypernet = false
  window = []
  valid = false
  line.each_char do |c|
    case c
    when '['
      hypernet = true
      window = []
    when ']'
      hypernet = false
      window = []
    else
      window.shift unless window.length < WIN_LEN
      window << c

      if window.length >= WIN_LEN && window[0] != window[1] && window[0..1] == window[2..3].reverse
        if hypernet
          valid = false
          break
        else
          valid = true
        end
      end
    end
  end
  valid
end
puts tls
