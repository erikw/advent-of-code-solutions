# frozen_string_literal: true

require 'set'

class Group
  attr_accessor :units, :damage
  attr_reader :army, :id, :hp, :attack, :weaknesses, :immunities, :initiative

  def initialize(army, id, units, hp, attack, damage, weaknesses, immunities, initiative)
    @army = army
    @id = id
    @units = units
    @hp = hp
    @attack = attack
    @damage = damage
    @weaknesses = weaknesses
    @immunities = immunities
    @initiative = initiative
  end

  def to_s
    "#{name}(#{@units} units)"
  end
  alias inspect to_s

  def name
    "#{@army.to_s.capitalize} ##{@id}"
  end

  def hash
    state.hash
  end

  def eql?(other)
    other.class == self.class && other.state == state
  end
  alias == eql?

  def effective_power
    @units * @damage
  end

  def select_target(groups, attacking, defending)
    enemy = enemies(groups).difference(defending).sort_by do |e|
      [-attacking_damage(e), -e.effective_power, -e.initiative]
    end.first
    return if enemy.nil? || attacking_damage(enemy) == 0

    attacking[name] = enemy
    defending << enemy
  end

  def attack(defender)
    return false if @units.zero?

    full_units = attacking_damage(defender) / defender.hp
    defender.units = [0, defender.units - full_units].max
    full_units > 0
  end

  protected

  def state
    [@army, @id, @units, @hp, @attack, @damage, @weaknesses, @immunities, @initiative]
  end

  private

  def enemies(groups)
    groups.reject { |g| g.army == @army }
  end

  def attacking_damage(enemy)
    damage = effective_power
    if enemy.immunities.include?(@attack)
      damage = 0
    elsif enemy.weaknesses.include?(@attack)
      damage *= 2
    end
    damage
  end
end

def parse_group(line, id, army)
  m = line.match(R_GROUP)
  weaknesses = Set.new
  immunities = Set.new
  unless m['listings'].nil?
    m['listings'].split(';').each do |listing|
      dest = listing.strip.start_with?('weak') ? weaknesses : immunities
      listing.sub(/^ ?\w+ \w+ /, '').split(', ').each { |attack| dest << attack }
    end
  end
  Group.new(army, id, m['units'].to_i, m['hp'].to_i, m['attack'], m['damage'].to_i, weaknesses, immunities,
            m['initiative'].to_i)
end

R_GROUP = /(?<units>\d+) units each with (?<hp>\d+) hit points (?:\((?<listings>[^)]+)\) )?with an attack that does (?<damage>\d+) (?<attack>\w+) damage at initiative (?<initiative>\d+)/

def parse_input
  groups_immune = []
  line = ARGF.readline
  id = 1
  until (line = ARGF.readline.chomp).empty?
    groups_immune << parse_group(line, id, :immune)
    id += 1
  end

  groups_infection = []
  ARGF.readline
  id = 1
  until ARGF.eof?
    groups_infection << parse_group(ARGF.readline.chomp, id, :infection)
    id += 1
  end
  groups = groups_immune + groups_infection
end

def battle(battle_groups)
  groups = battle_groups.dup
  until groups.select { |g| g.army == :immune }.count.zero? || groups.select { |g| g.army == :infection }.count.zero?
    attacking = {} # name -> Group
    defending = []
    groups.sort_by { |g| [-g.effective_power, -g.initiative] }.each do |attacker|
      attacker.select_target(groups, attacking, defending)
    end

    attacks = 0
    groups.sort_by(&:initiative).reverse_each do |attacker|
      defender = attacking[attacker.name]
      next if defender.nil?

      attacks += 1 if attacker.attack(defender)
      groups.delete(defender) if defender.units.zero?
    end
    return [0, nil] if attacks.zero?
  end
  [groups.map(&:units).sum, groups.first.army]
end
