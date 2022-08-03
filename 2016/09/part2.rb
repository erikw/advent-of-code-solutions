#!/usr/bin/env ruby
# frozen_string_literal: true

MARKER = /\((\d+)x(\d+)\)/
compressed = ARGF.readline.chomp.chars


# Too slow.
# i = 0
# while i < compressed.length
#   if compressed[i] == '('
#     len, rep, jump = compressed.join.match(MARKER) do |match|
#       match.nil? ? [nil, nil] : [match[1].to_i, match[2].to_i, match[0].length]
#     end
#     insert = compressed[i + jump, len] * rep
#     (jump + len).times { compressed.delete_at(i) }
#     compressed.insert(i, *insert)
#   else
#     i += 1
#   end
# end
# puts compressed.join
# len = compressed.join.each_char.count { |c| c != ' ' }
# puts len



# Too deep recursion stack.
# def decompressed_len(str, cache={})
#  if !cache.key?(str)
#    if str.length == 0
#      cache[str] = 0
#    elsif str[0] == '('
#      len, rep, jump = str.join.match(MARKER) do |match|
#        match.nil? ? [nil, nil] : [match[1].to_i, match[2].to_i, match[0].length]
#      end
#      insert = str[jump, len] * rep
#      (jump + len).times { str.delete_at(0) }
#      str.insert(0, *insert)
#
#      cache[str] = decompressed_len(str)
#    else
#      cache[str] = 1 + decompressed_len(str[1..])
#    end
#  end
#  cache[str]
# end

# Recurse on individual parts and multiply the repeat.
# Props to https://www.reddit.com/r/adventofcode/comments/5hbygy/comment/daz2o0d/
def decompressed_len(str, cache={})
  unless cache.key? str
    pos = str.join.index(MARKER)
    if pos.nil?
      cache[str] = str.length
    else
      len, rep, jump = str.join.match(MARKER) do |match|
        [match[1].to_i, match[2].to_i, match[0].length]
      end

      i = pos + jump
      cache[str] = str[...pos].length + decompressed_len(str[i, len]) * rep + decompressed_len(str[i+len...])
    end
  end
  cache[str]
end

puts decompressed_len(compressed)


# NOTE coolest algo is probably https://www.reddit.com/r/adventofcode/comments/5hbygy/comment/dazentu/
