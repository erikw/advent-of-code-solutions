DEBUG = false
# DEBUG = true
def dbg(msg = '')
  puts msg if DEBUG
end

SYM_WALL = '#'
SYM_OPEN = '.'
SYM_GOBLIN = 'G'
SYM_ELF = 'E'

class Unit
  attr_reader :attack
  attr_accessor :x, :y, :hp

  NEIGHBORS_DELTAS = [[-1, 0], [1, 0], [0, -1], [0, 1]]

  def initialize(x, y, attack = 3)
    @x = x
    @y = y
    @hp = 200
    @attack = attack
  end

  def pos # TODO: move out coordinates from class and have only as key in hash?
    [@x, @y]
  end

  def to_s
    "#{@x}, #{@y}, #{@hp}hp"
  end

  def dead?
    @hp <= 0
  end

  def attack?(map, units, elf_quit = false)
    enemies = units.values.select do |unit|
      in_range = false
      if unit.is_a?(enemy)
        dist_diff = [@x, @y].zip([unit.x, unit.y]).map { |a, b| (a - b).abs }
        in_range = [[1, 0], [0, 1]].include?(dist_diff)
      end
      in_range
    end
    # dbg "Enemies of #{self}: #{enemies}"
    enemy = enemies.sort_by { |enemy| [enemy.hp, enemy.x, enemy.y] }.first
    unless enemy.nil?
      enemy.hp -= @attack unless enemy.nil?
      if enemy.hp <= 0
        raise 'Elf dies!' if enemy.is_a?(Elf) && elf_quit

        dbg "#{self} killed #{enemy}"
        units.delete(enemy.pos)
        map[enemy.x][enemy.y] = SYM_OPEN
      end
    end
    !enemy.nil?
  end

  def move(map, units)
    in_range = units.values.select { |u| u.is_a?(enemy) }.map do |enemy|
      NEIGHBORS_DELTAS.map do |dx, dy|
        map[enemy.x + dx][enemy.y + dy] == SYM_OPEN ? [enemy.x + dx, enemy.y + dy] : nil
      end
    end.flatten(1).compact.uniq

    path = shortest_path_to_a_target(map, units, in_range)
    unless path.nil?
      next_pos = path[1]
      map[next_pos[0]][next_pos[1]] = map[@x][@y]
      map[@x][@y] = SYM_OPEN
      units.delete(pos)
      units[next_pos] = self
      @x = next_pos[0]
      @y = next_pos[1]
    end
    !path.nil?
  end

  def eql?(other)
    other.class = self.class && other.state == state
  end
  alias == eql?

  def hash
    state.hash
  end

  protected

  def state
    [@x, @y, @hp, @attack]
  end

  private

  def dijksta(map)
    dist = Hash.new(Float::INFINITY)
    dist[pos] = 0
    prev = Hash.new { |h, k| h[k] = [] }
    visited = Set.new

    q = MinPriorityQueue.new
    q.push(pos, dist[pos])
    until q.empty?
      u = q.pop
      visited << u

      NEIGHBORS_DELTAS.map do |dx, dy|
        npos = [u[0] + dx, u[1] + dy]
        next if visited.include?(npos) || map[npos[0]][npos[1]] != SYM_OPEN

        alt = dist[u] + 1
        next unless alt <= dist[npos]

        dist[npos] = alt
        prev[npos] << u
        begin
          q.change_priority(npos, alt)
        rescue StandardError
          q.push(npos, alt)
        end
      end
    end
    [dist, prev]
  end

  def all_paths_to(cur_pos, prev)
    paths = []
    if cur_pos == pos
      paths << [pos]
    elsif prev.key?(cur_pos)
      prev[cur_pos].each do |prev_pos|
        # paths << all_paths_to(prev_pos, prev) + [cur_pos]
        # all_paths_to(prev_pos, prev).each do |path|
        #  paths << path + [cur_pos]
        # end
        all_paths = all_paths_to(prev_pos, prev)
        all_paths.each do |path|
          paths << path + [cur_pos]
        end
      end
    end
    paths
  end

  # Dijkstra's algorithm finding all shortest paths to given targets.
  def shortest_path_to_a_target(map, _units, targets)
    dist, prev = dijksta(map)
    # min_dist_target = targets.min_by { |target| dist[target] }
    min_dist_target = targets.sort_by { |target| [dist[target], target] }.first
    if dist[min_dist_target] == Float::INFINITY
      nil
    else
      paths = all_paths_to(min_dist_target, prev)
      paths.sort_by { |path| path[1] }.first
    end
  end
end

class Elf < Unit
  def to_s
    "Elf(#{super})"
  end
  alias inspect to_s

  def enemy
    Goblin
  end
end

class Goblin < Unit
  def to_s
    "Goblin(#{super})"
  end
  alias inspect to_s

  def enemy
    Elf
  end
end

def print_map(map, units)
  map.each.with_index do |row, x|
    hp_row = units.values.select do |unit|
      unit.x == x
    end.sort_by { |unit| unit.y }.map { |u| "#{u.class.name[0]}(#{u.hp})" }.join(', ')
    dbg "#{row.join}   #{hp_row}"
  end
end

def read_input
  ARGF.each_line.map { |l| l.chomp.chars }
end

def create_units(map, elf_attack = 3)
  units = {}
  (0...map.length).each do |x|
    (0...map[0].length).each do |y|
      if map[x][y] == SYM_ELF
        units[[x, y]] = Elf.new(x, y, elf_attack)
      elsif map[x][y] == SYM_GOBLIN
        units[[x, y]] = Goblin.new(x, y)
      end
    end
  end
  units
end

def play_game(map, units, elf_quit: false)
  round = 0
  catch :game_ended do
    loop do
      dbg "\nAfter #{round} rounds:"
      print_map(map, units)
      sleep 0.4 if DEBUG

      units.sort_by { |p, _u| p }.each do |_pos, unit|
        throw :game_ended if units.values.map(&:class).uniq.length == 1
        next if unit.dead? || unit.attack?(map, units, elf_quit)

        next unless unit.move(map, units)

        unit.attack?(map, units, elf_quit)
      end
      round += 1
    end
  end

  dbg "\nGame ended after #{round} full rounds:"
  print_map(map, units)
  dbg

  round * units.values.map { |u| u.hp }.sum
end
