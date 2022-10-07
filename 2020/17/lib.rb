require 'set'

BOOT_CYCLES = 6

SYM_ACTIVE = '#'
SYM_INACTIVE = '.'

def neighbour_positions(pos, dimensions)
  deltas = dimensions.times.map { [-1, 0, 1] }.inject(&:product).map(&:flatten).reject { |d| d == [0] * dimensions }
  deltas.map do |delta|
    pos.zip(delta).map { |a, b| a + b }
  end
end

def active_neighbours(cubes, pos)
  neighbour_positions(pos, cubes.keys.first.length).count do |pos_n|
    cubes[pos_n]
  end
end

def update_next(cubes, cubes_next, pos)
  neighbours = active_neighbours(cubes, pos)
  cubes_next[pos] = if cubes[pos]
                      [2, 3].include?(neighbours)
                    else
                      3 == neighbours
                    end
end

def run(cubes, cycles)
  cubes_orig = cubes
  dimensions = cubes.keys.first.length
  cycles.times do
    cubes_next = cubes.dup

    checked = Set.new
    cubes.each_key do |pos|
      unless checked.include?(pos)
        update_next(cubes, cubes_next, pos)
        checked << pos
      end

      neighbour_positions(pos, dimensions).each do |pos_n|
        unless checked.include?(pos_n)
          update_next(cubes, cubes_next, pos_n)
          checked << pos_n
        end
      end
    end

    cubes = cubes_next
  end
  cubes_orig.replace(cubes)
end
