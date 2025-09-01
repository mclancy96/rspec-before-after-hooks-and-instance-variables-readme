# lib/recipe_box.rb
require_relative 'recipe'

class RecipeBox
  attr_reader :recipes

  def initialize
    @recipes = []
  end

  def add_recipe(recipe)
    @recipes << recipe
  end

  def remove_recipe(recipe)
    @recipes.delete(recipe)
  end

  def find_recipe(name)
    @recipes.find { |r| r.name == name }
  end

  def clear
    @recipes.clear
  end
end
