# frozen_string_literal: true

def inv_reactions_from_input
  inv_reactions = {}
  ARGF.each_line do |line|
    chems = line.chomp.scan(/\d+ [A-Z]+/).map(&:split).map { |a, c| [a.to_i, c] }
    output = chems.pop
    inv_reactions[output[1]] = [output[0], chems]
  end
  inv_reactions
end

def fuel_cost(inv_reactions, fuel)
  ores_bought = 0
  chemicals = Hash.new(0)
  chemicals['FUEL'] = fuel
  buffers = Hash.new(0) # checmical => amount

  until chemicals.empty?
    chem_needed = chemicals.keys.first
    amount_needed = chemicals.delete(chem_needed)

    chem_free = [buffers[chem_needed], amount_needed].min
    amount_needed -= chem_free
    buffers[chem_needed] -= chem_free

    amount_prod, chems_prod = inv_reactions[chem_needed]
    num_prods = (amount_needed / amount_prod.to_f).ceil
    buffers[chem_needed] += num_prods * amount_prod - amount_needed

    chems_prod.each do |amount_chem, chem_prod|
      if chem_prod == 'ORE'
        ores_bought += num_prods * amount_chem
      else
        chemicals[chem_prod] += num_prods * amount_chem
      end
    end
  end

  ores_bought
end
