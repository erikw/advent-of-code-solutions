def dance(programs, moves)
  moves.each do |move|
    case move
    when /s(\d+)/ # Spin
      x = Regexp.last_match(1).to_i
      programs.unshift(*programs.pop(x))
    when %r{x(\d+)/(\d+)} # Exchange
      a = Regexp.last_match(1).to_i
      b = Regexp.last_match(2).to_i
      programs[a], programs[b] = programs[b], programs[a]
    when %r{p([a-z])/([a-z])} # Partner
      a = programs.index(Regexp.last_match(1))
      b = programs.index(Regexp.last_match(2))
      programs[a], programs[b] = programs[b], programs[a]
    end
  end
end
