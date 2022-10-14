#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

ingredient_counts, ingredient2allergenscount = count_input
non_allergens = non_allergens(ingredient2allergenscount)

non_allergens.each do |nallergen|
  ingredient2allergenscount.delete(nallergen)
end

ingredient2allergen = {} # Final true mapping
loop do
  eleminated_allergens = []
  ingredient2allergenscount.each do |ingredient, counts|
    if counts.length == 1
      ingredient2allergen[ingredient] = counts.keys.first
      eleminated_allergens << counts.keys.first
    end
  end
  ingredient2allergenscount.each do |_ingredient, counts|
    eleminated_allergens.each do |eleminated_allergen|
      counts.delete(eleminated_allergen)
    end
  end
  break if eleminated_allergens.empty?
end

canonical_list = ingredient2allergen.to_a.sort_by(&:last).map(&:first).join(',')
puts canonical_list
