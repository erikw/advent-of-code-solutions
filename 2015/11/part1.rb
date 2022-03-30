#!/usr/bin/env ruby

def pw_valid(password)
  triplet = password.chars.each_cons(3).map { |chrs| chrs.map(&:ord) }.any? do |a, b, c|
    (a + 1) == b && b == (c - 1)
  end
  double = password.chars.each_with_index.each_cons(2).select do |a, b|
             a[0] == b[0]
           end.map { |a, b| [a[1], b[1]] }.reduce([]) do |acc, a|
    if acc.empty? || acc.last.last != a[0]
      acc << a
    else
      acc
    end
  end.length >= 2

  triplet && double
end

def pw_next(password)
  pos = password.length - 1
  loop do
    password[pos] = (((password[pos].ord + 1 - 'a'.ord) % ('z'.ord + 1 - 'a'.ord)) + 'a'.ord).chr
    next if %w[i o l].include?(password[pos])
    break if pos == 0 || password[pos] != 'a'

    pos -= 1
  end
end

password = ARGF.readline.chomp

loop do
  pw_next(password)
  break if pw_valid(password)
end

puts password
