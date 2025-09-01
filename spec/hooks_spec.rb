
require_relative '../lib/recipe_box'
require_relative '../lib/recipe'

RSpec.describe 'Before/After Hooks and Instance Variables (RecipeBox examples)' do
  before(:each) do
    @box = RecipeBox.new
    @recipe = Recipe.new('Pancakes', ['flour', 'milk', 'egg'])
    @box.add_recipe(@recipe)
  end

  after(:each) do
    @box.clear
  end

  it 'sets up a new RecipeBox and Recipe before each example' do
    expect(@box.recipes).to include(@recipe)
  end

  it 'can add a new recipe in an example' do
    new_recipe = Recipe.new('Omelette', ['egg', 'cheese'])
    @box.add_recipe(new_recipe)
    expect(@box.recipes).to include(new_recipe)
  end

  it 'removes a recipe in an example' do
    @box.remove_recipe(@recipe)
    expect(@box.recipes).not_to include(@recipe)
  end

  it 'does not persist changes between examples' do
    expect(@box.recipes.size).to eq(1)
  end

  it 'can modify the recipe ingredients' do
    @recipe.add_ingredient('syrup')
    expect(@recipe.ingredients).to include('syrup')
  end

  it 'cleans up the RecipeBox after each example' do
    # after(:each) clears the box, so this should always be true at the start
    expect(@box.recipes.size).to eq(1)
  end

  context 'with before(:all) and after(:all)' do
    before(:all) do
      @shared_box = RecipeBox.new
      @shared_recipe = Recipe.new('Toast', ['bread', 'butter'])
      @shared_box.add_recipe(@shared_recipe)
    end

    after(:all) do
      @shared_box.clear
    end

    it 'shares state across examples in before(:all)' do
      expect(@shared_box.recipes).to include(@shared_recipe)
    end

    it 'modifies shared state (not recommended)' do
      @shared_recipe.add_ingredient('jam')
      expect(@shared_recipe.ingredients).to include('jam')
    end
  end

  it 'shows that instance variables from before(:each) are not shared' do
    @box.add_recipe(Recipe.new('Waffles', ['flour', 'egg']))
    expect(@box.find_recipe('Waffles')).not_to be_nil
  end

  it 'shows that instance variables from before(:all) are shared (pitfall)' do
    skip 'Student exercise: Try modifying @shared_box in multiple examples and observe the result.'
  end

  it 'uses after(:each) for cleanup' do
    # after(:each) runs after this example, so @box will be cleared
    expect(@box.recipes).to include(@recipe)
  end

  it 'uses after(:all) for cleanup (pending)' do
    skip 'Student exercise: Add an after(:all) hook to clear a shared resource.'
  end
end
