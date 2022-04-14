class Spell
  attr_accessor :turns

  def initialize(turns)
    @turns = turns
  end

  def activate(_from, _to)
    @turns -= 1
  end

  def active?
    @turns > 0
  end
end

class MagicMissile < Spell
  COST = 53

  def initialize(from, to)
    super(1)
    @damage = 4

    activate(from, to)
  end

  def activate(from, to)
    super
    to.hp -= @damage
  end
end

class Drain < Spell
  COST = 73

  def initialize(from, to)
    super(1)
    @damage = 2
    @heal = 2

    activate(from, to)
  end

  def activate(from, to)
    super
    to.hp -= @damage
    from.hp += @heal
  end
end

class Shield < Spell
  COST = 113

  def initialize(from, _to)
    super(6)
    @armor = 7

    from.armor += @armor
  end

  def activate(from, to)
    super
    from.armor -= @armor if @turns == 0
  end
end

class Poison < Spell
  COST = 173

  def initialize(_from, _to)
    super(6)
    @damage = 3
  end

  def activate(from, to)
    super
    to.hp -= @damage
  end
end

class Recharge < Spell
  COST = 229

  def initialize(_from, _to)
    super(5)
    @mana = 101
  end

  def activate(from, _to)
    super
    from.mana += @mana
  end
end
