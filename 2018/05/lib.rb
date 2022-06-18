def react(polymer)
  stack = []
  polymer.each do |p|
    if !stack.last.nil? && stack.last.downcase == p.downcase && stack.last != p
      stack.pop
    else
      stack << p
    end
  end
  stack
end
