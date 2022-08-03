#!/usr/bin/env ruby
# frozen_string_literal: true
# start = ARGF.each_line.map do |line|
# line.chomp.delete(' .#').chars
# end.delete_if(&:empty?).transpose

# Solved by hand. Winning energy-sequence for ./input is:
# 6A, 6B, 3A, 6D, 5C, 7D, 3B, 4B, 7C, 3A, 8A
puts 14350
exit

ROW_HALLWAY = 1
ROW_ROOM_TOP = 2
ROW_ROOM_BOTTOM = 3

COL_A = 3
COL_B = 5
COL_C = 7
COL_D = 9

char2col = {
  'A' => COL_A,
  'B' => COL_B,
  'C' => COL_C,
  'd' => COL_D
}

char2energy = {
  'A' => 1,
  'B' => 10,
  'C' => 100,
  'd' => 1000
}

def all_in_place(map)
  map[ROW_ROOM_TOP][COL_A] == 'A' && map[ROW_ROOM_TOP + 1][COL_A] == 'A' &&
    map[ROW_ROOM_TOP][COL_B] == 'B' && map[ROW_ROOM_TOP + 1][COL_B] == 'B' &&
    map[ROW_ROOM_TOP][COL_C] == 'C' && map[ROW_ROOM_TOP + 1][COL_C] == 'C' &&
    map[ROW_ROOM_TOP][DOL_D] == 'D' && map[ROW_ROOM_TOP + 1][DOL_D] == 'D'
end

map = ARGF.each_line.map { |line| line.chomp }

puts '=' * 20
puts 'Start state: '
puts map

energy = 0
until all_in_place(map)
  energy_before = energy
  puts '=' * 20

  # Look for char to bring home to base
  moved = false
  map[ROW_HALLWAY].chars.each_with_index do |char, char_i|
    next unless %w[A B C D].include? char

    col_home = char2col[char]
    if col_home > char_i
      path_start = char_i + 1
      path_end = col_home
    else
      path_start = col_home
      path_end = char_i - 1
    end
    if map[ROW_HALLWAY][path_start..path_end].chars.all? { |c| c == '.' } &&
        map[ROW_ROOM_BOTTOM][col_home] == '.' && map[ROW_ROOM_TOP][col_home] == '.'
      puts "We can move #{char} from hallway to #{col_home} bottom"
      map[ROW_HALLWAY][char_i] = '.'
      map[ROW_ROOM_BOTTOM][col_home] = char
      energy += char2energy[char] * (path_end - path_start + 1) + 1
      moved = true
    elsif map[ROW_HALLWAY][path_start..path_end].chars.all? { |c| c == '.' } &&
      map[ROW_ROOM_BOTTOM][col_home] == 'A' && map[ROW_ROOM_TOP][col_home] == '.'
      puts "We can move #{char} from hallway to #{col_home} top"
      map[ROW_HALLWAY][char_i] = '.'
      map[ROW_ROOM_TOP][col_home] = char
      energy += char2energy[char] * (path_end - path_start + 1) + 2
      moved = true
    end
  end
  next if moved

  # Bring someone out to hallway, at position minimizing return to home base
  unless map[ROW_ROOM_BOTTOM][COL_D] == 'D' && map[ROW_ROOM_TOP][COL_D] == 'D'
    col_d_1 = nil
    col_d_2 = nil
    if map[ROW_ROOM_BOTTOM][COL_A] == 'D'
      if col_d_1.nil?
        col_d_1 = COL_A
      else
        col_d_2 = COL_A
      end
    end
    if map[ROW_ROOM_TOP][COL_A] == 'D'
      if col_d_1.nil?
        col_d_1 = COL_A
      else
        col_d_2 = COL_A
      end
    end

    if map[ROW_ROOM_BOTTOM][COL_B] == 'D'
      if col_d_1.nil?
        col_d_1 = COL_B
      else
        col_d_2 = COL_B
      end
    end
    if map[ROW_ROOM_TOP][COL_B] == 'D'
      if col_d_1.nil?
        col_d_1 = COL_B
      else
        col_d_2 = COL_B
      end
    end

    if map[ROW_ROOM_BOTTOM][COL_C] == 'D'
      if col_d_1.nil?
        col_d_1 = COL_C
      else
        col_d_2 = COL_C
      end
    end
    if map[ROW_ROOM_TOP][COL_C] == 'D'
      if col_d_1.nil?
        col_d_1 = COL_C
      else
        col_d_2 = COL_C
      end
    end

    if map[ROW_ROOM_BOTTOM][COL_D] == 'D'
      if col_d_1.nil?
        col_d_1 = COL_D
      else
        col_d_2 = COL_D
      end
    end
    if map[ROW_ROOM_TOP][COL_D] == 'D'
      if col_d_1.nil?
        col_d_1 = COL_D
      else
        col_d_2 = COL_D
      end
    end

    puts '*' * 10
    puts "After iteration, energy=#{energy} and maps looks like:"
    puts map
    break if energy_before == energy
  end
