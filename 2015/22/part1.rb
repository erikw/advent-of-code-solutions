#!/usr/bin/env ruby

require_relative 'spells'
require_relative 'characters'

def take_turn(player, boss, turn, min_mana = Float::INFINITY)
  if boss.hp <= 0
    return [true, player.mana_spent, []]
  elsif player.hp <= 0 || player.mana_spent >= min_mana
    return [false, player.mana_spent, []]
  end

  player.activate_spells(boss)

  if turn == :boss
    boss.attack(player)
    take_turn(player, boss, :player, min_mana)
  else
    winning_spells = []
    Player::SPELLS.each do |spell|
      player_clone = Marshal.load(Marshal.dump(player))
      boss_clone = Marshal.load(Marshal.dump(boss))
      next unless player_clone.cast?(spell, boss_clone)

      pwon, mana, spells = take_turn(player_clone, boss_clone, :boss, min_mana)
      next unless pwon && mana < min_mana

      min_mana = mana
      winning_spells = [spell] + spells
    end
    [!winning_spells.empty?, min_mana, winning_spells]
  end
end

player = Player.new(50, 500)
boss = Boss.new(ARGF.readline.split[2].to_i, ARGF.readline.split[1].to_i)

_, mana, spells = take_turn(player, boss, :player)
puts spells.join(' => ')
puts mana

## Fight 1
# player = Player.new(10, 250)
# boss = Boss.new(13, 8)

# puts '-- Player turn --'
# puts "- #{player.stats}"
# puts "- #{boss.stats}"
# player.activate_spells(boss)
# player.cast?(Poison, boss)

# puts '-- Boss turn --'
# puts "- #{player.stats}"
# puts "- #{boss.stats}"
# player.activate_spells(boss)
# boss.attack(player)

# puts '-- Player turn --'
# puts "- #{player.stats}"
# puts "- #{boss.stats}"
# player.activate_spells(boss)
# player.cast?(MagicMissile, boss)

# puts '-- Boss turn --'
# puts "- #{player.stats}"
# puts "- #{boss.stats}"
# player.activate_spells(boss)
## boss.attack(player)

# puts 'End game?'
# puts "- #{player.stats}"
# puts "- #{boss.stats}"

# Fight 2
# player = Player.new(10, 250)
# boss = Boss.new(14, 8)

# puts '-- Player turn --'
# puts "- #{player.stats}"
# puts "- #{boss.stats}"
# player.activate_spells(boss)
# player.cast?(Recharge, boss)

# puts '-- Boss turn --'
# puts "- #{player.stats}"
# puts "- #{boss.stats}"
# player.activate_spells(boss)
# boss.attack(player)

# puts '-- Player turn --'
# puts "- #{player.stats}"
# puts "- #{boss.stats}"
# player.activate_spells(boss)
# player.cast?(Shield, boss)

# puts '-- Boss turn --'
# puts "- #{player.stats}"
# puts "- #{boss.stats}"
# player.activate_spells(boss)
# boss.attack(player)

# puts '-- Player turn --'
# puts "- #{player.stats}"
# puts "- #{boss.stats}"
# player.activate_spells(boss)
# player.cast?(Drain, boss)

# puts '-- Boss turn --'
# puts "- #{player.stats}"
# puts "- #{boss.stats}"
# player.activate_spells(boss)
# boss.attack(player)

# puts '-- Player turn --'
# puts "- #{player.stats}"
# puts "- #{boss.stats}"
# player.activate_spells(boss)
# player.cast?(Poison, boss)

# puts '-- Boss turn --'
# puts "- #{player.stats}"
# puts "- #{boss.stats}"
# player.activate_spells(boss)
# boss.attack(player)

# puts '-- Player turn --'
# puts "- #{player.stats}"
# puts "- #{boss.stats}"
# player.activate_spells(boss)
# player.cast?(MagicMissile, boss)

# puts '-- Boss turn --'
# puts "- #{player.stats}"
# puts "- #{boss.stats}"
# player.activate_spells(boss)
## boss.attack(player)

# puts 'End game?'
# puts "- #{player.stats}"
# puts "- #{boss.stats}"
