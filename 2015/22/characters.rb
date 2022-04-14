require_relative 'spells'

class Character
  attr_accessor :hp, :damage, :armor

  def initialize(hp, damage, armor)
    @hp = hp
    @damage = damage
    @armor = armor
  end
end

class Player < Character
  SPELLS = [MagicMissile, Drain, Shield, Poison, Recharge]

  attr_accessor :mana
  attr_reader :mana_spent

  def initialize(hp, mana)
    super(hp, 0, 0)
    @mana = mana
    @mana_spent = 0
    @active_spells = []
  end

  def to_s
    "Player(hp=#{@hp}, damge=#{@damage}, armor=#{@armor}, mana=#{@mana}, mana_spent=#{@mana_spent})"
  end
  alias inspect to_s

  def stats
    "Player has #{@hp} hit point, #{@armor} armor, #{mana} mana"
  end

  def activate_spells(opponent)
    @active_spells.select! do |spell|
      spell.activate(self, opponent)
      spell.active?
    end
  end

  def cast?(spell_class, opponent)
    if @active_spells.map(&:class).include?(spell_class) || spell_class::COST > @mana
      false
    else
      spell = spell_class.new(self, opponent)
      @mana -= spell_class::COST
      @mana_spent += spell_class::COST
      @active_spells << spell if spell.active?
      true
    end
  end
end

class Boss < Character
  def initialize(hp, damage)
    super(hp, damage, 0)
  end

  def stats
    "Boss has #{@hp} hit point"
  end

  def attack(player)
    player.hp -= [1, @damage - player.armor].max
  end
end
