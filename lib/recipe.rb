# lib/recipe.rb
class Recipe
  attr_reader :name, :ingredients

  def initialize(name, ingredients)
    @name = name
    @ingredients = ingredients
  end

  def add_ingredient(ingredient)
    @ingredients << ingredient
  end

  def remove_ingredient(ingredient)
    @ingredients.delete(ingredient)
  end

  def ingredient_count
    @ingredients.size
  end
end
