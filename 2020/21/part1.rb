#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

ingredient_counts, ingredient2allergenscount = count_input
non_allergens = non_allergens(ingredient2allergenscount)

non_aller_occurences = non_allergens.sum do |nallergen|
  ingredient_counts[nallergen]
end

puts non_aller_occurences
