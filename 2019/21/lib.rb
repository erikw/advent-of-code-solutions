def read(computer)
  answer = [[]]
  until computer.stdout.empty?
    answer.last << computer.stdout.pop
    next unless answer.last.last == "\n".ord

    answer << []
  end
  answer
end

def read_print(computer, verbose = false)
  answer = read(computer)
  extra = answer[..-2]
  last = answer.last
  extra.each { |l| puts l.map(&:chr).join } if verbose
  puts last.join unless last.empty?
end

def input(computer, string, print = true)
  puts string if print
  string.each_char.map(&:ord).each do |char|
    computer.stdin << char
  end
end

def run(computer)
  next until [Computer::STATUS_INPUT_NEEDED, Computer::STATUS_DONE].include? computer.execute
end
