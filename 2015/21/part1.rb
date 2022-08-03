#!/usr/bin/env ruby
# frozen_string_literal: true

class Character
  attr_accessor :hp, :damage, :armor
  attr_reader :name

  def initialize(name, hp, damage, armor)
    @name = name
    @hp = hp
    @damage = damage
    @armor = armor
  end

  def wins?(other)
    hits = [1, @damage - other.armor].max
    hits_other = [1, other.damage - @armor].max

    turns = (other.hp / hits.to_f).ceil
    turns_other = (@hp / hits_other.to_f).ceil
    turns <= turns_other
  end
end

SHOP = {
  weapons: [
    ['Dagger', 8, 4, 0],
    ['Shortsword',   10,     5,       0],
    ['Warhammer',    25,     6,       0],
    ['Longsword',    40,     7,       0],
    ['Greataxe',     74,     8,       0]
  ],
  armor: [
    ['Leather',      13,     0,       1],
    ['Chainmail',    31,     0,       2],
    ['Splintmail',   53,     0,       3],
    ['Bandedmail',   75,     0,       4],
    ['Platemail',    102,    0,       5]
  ],
  rings: [
    ['Damage +1',    25,     1,       0],
    ['Damage +2',    50,     2,       0],
    ['Damage +3',    100,    3,       0],
    ['Defense +1',   20,     0,       1],
    ['Defense +2',   40,     0,       2],
    ['Defense +3',   80,     0,       3]
  ]
}

# player = Character.new('Player', 8, 5, 5)
# boss = Character.new('Boss', 12, 7, 2)
# puts player.wins?(boss)

player = Character.new('Player', 100, 0, 0)
boss = Character.new('Boss', ARGF.readline.split[2].to_i, ARGF.readline.split[1].to_i, ARGF.readline.split[1].to_i)
cost_lowest = Float::INFINITY
SHOP[:weapons].each do |_, wcost, wdamage, warmor|
  cost_total = wcost
  player.damage = wdamage
  player.armor = warmor
  if player.wins?(boss)
    cost_lowest = [cost_lowest, cost_total].min
    next
  end

  SHOP[:armor].each do |_, acost, adamage, aarmor|
    cost_total = wcost + acost
    player.damage = wdamage + adamage
    player.armor = warmor + aarmor
    if player.wins?(boss)
      cost_lowest = [cost_lowest, cost_total].min
      next
    end

    SHOP[:rings].each do |_, rcost, rdamage, rarmor|
      cost_total = wcost + acost + rcost
      player.damage = wdamage + adamage + rdamage
      player.armor = warmor + aarmor + rarmor
      if player.wins?(boss)
        cost_lowest = [cost_lowest, cost_total].min
        next
      end

      SHOP[:rings].each do |_, rcost2, rdamage2, rarmor2|
        cost_total = wcost + acost + rcost + rcost2
        player.damage = wdamage + adamage + rdamage + rdamage2
        player.armor = warmor + aarmor + rarmor + rarmor2
        cost_lowest = [cost_lowest, cost_total].min if player.wins?(boss)
      end
    end
  end
end

puts cost_lowest
