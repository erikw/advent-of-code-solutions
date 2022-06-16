IMAGE_START = [
  ['.', '#', '.'],
  ['.', '.', '#'],
  ['#', '#', '#']
].freeze

def flip(image)
  image.map(&:reverse)
end

def rotate(image)
  flip(image.transpose)
end

def square_key(square)
  square.map(&:join).join
end

def parse_rules(input)
  rules = {}
  input.each_line do |line|
    from, to = line.split('=>').map { |part| part.strip.split('/').map(&:chars) }
    from_flip = flip(from)

    4.times do |i|
      rules[square_key(from)] = to
      rules[square_key(from_flip)] = to
      unless i == 3
        from = rotate(from)
        from_flip = flip(from)
      end
    end
  end
  rules
end

def enhance_image(image, iterations, rules)
  image = image.dup
  iterations.times do
    image_new = []
    step = image.length.even? ? 2 : 3

    (0...image.length).step(step) do |row|
      squares = Array.new(image.length / step) { [] }

      step.times do |dr|
        (0...image[0].length).step(step) do |col|
          squares[col / step] << image[row + dr][col...(col + step)]
        end
      end

      squares_enhanced = squares.each.map { |sq| rules[square_key(sq)] }
      (step + 1).times do |sq_row|
        image_new << squares_enhanced.map { |sq| sq[sq_row] }.inject(&:+)
      end
    end
    image = image_new
  end

  image
end
