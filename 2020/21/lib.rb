# frozen_string_literal: true

def count_input
  ingredient_counts = Hash.new(0)
  ingredient2allergenscount = Hash.new { |h, k| h[k] = Hash.new(0) } # ingredient -> {allergen -> food_count}
  ARGF.each_line do |line|
    ingredients, allergens = line.chomp(")\n").split(' (contains ').map { |parts| parts.split(/,? /) }
    ingredients.each do |ingredient|
      ingredient_counts[ingredient] += 1
    end
    ingredients.product(allergens).each do |ingredient, allergen|
      ingredient2allergenscount[ingredient][allergen] += 1
    end
  end

  [ingredient_counts, ingredient2allergenscount]
end

def max_counts_allergens(ingredient2allergenscount)
  max_counts = Hash.new(0)
  ingredient2allergenscount.values.each do |counts|
    counts.each do |allergen, count|
      max_counts[allergen] = [count, max_counts[allergen]].max
    end
  end
  max_counts
end

def non_allergens(ingredient2allergenscount)
  max_counts = max_counts_allergens(ingredient2allergenscount)
  non_allergens = []
  ingredient2allergenscount.each do |ingredient, counts|
    allergens_delete = []
    counts.each do |allergen, count|
      allergens_delete << allergen unless count == max_counts[allergen]
    end
    allergens_delete.each do |allergen|
      counts.delete(allergen)
    end
    non_allergens << ingredient if counts.empty?
  end
  non_allergens
end
