#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'spells'
require_relative 'characters'

def take_turn(player, boss, turn, min_mana = Float::INFINITY)
  if boss.hp <= 0
    return [true, player.mana_spent, []]
  elsif player.hp <= 0 || player.mana_spent >= min_mana
    return [false, player.mana_spent, []]
  end

  if turn == :player
    player.hp -= 1
    return [false, player.mana_spent, []] if player.hp <= 0
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
