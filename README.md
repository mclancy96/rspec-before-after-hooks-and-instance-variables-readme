# RSpec: Before/After Hooks and Instance Variables: DRYing Up Your Specs (and Your Tears)

Welcome to Lesson 6! If you’ve ever found yourself copying and pasting the same setup code into every test, this lesson is for you. Today, we’ll meet RSpec’s before/after hooks and instance variables—your new best friends for writing clean, DRY (Don’t Repeat Yourself) specs. We’ll go step by step, with lots of examples, analogies, and clarifications, so you’ll never wonder “where does this go?” again.

---

## Why DRY Matters in Testing

Imagine you’re baking cookies, and every time you want to add chocolate chips, you have to open a new bag. Wouldn’t it be easier to just pour them all into a bowl at the start? DRYing up your specs means setting up your test data once, so you don’t have to repeat yourself in every example.

## Meet the Hooks: before and after

RSpec gives you special blocks called hooks that run code before or after each example (or group of examples). The most common are `before(:each)`, `before(:all)`, and `after`. These hooks help you avoid repetition and keep your tests clean and predictable.

Here's a simple diagram to help you visualize how hooks work:

```zsh
before(:each)
  ↓
it block 1
after(:each)
  ↓
before(:each)
  ↓
it block 2
after(:each)
  ↓
...
```

### before(:each)

Runs before every single example in a group. Think of it as “resetting the stage” before each scene.

```ruby
# /spec/hooks_spec.rb
RSpec.describe RecipeBox do
  before(:each) do
    @box = RecipeBox.new
    @recipe = Recipe.new('Pancakes', ['flour', 'milk', 'egg'])
    @box.add_recipe(@recipe)
  end

  it "contains the added recipe" do
    expect(@box.recipes).to include(@recipe)
  end

  it "can add another recipe" do
    new_recipe = Recipe.new('Omelette', ['egg', 'cheese'])
    @box.add_recipe(new_recipe)
    expect(@box.recipes).to include(new_recipe)
  end
end
```

### before(:all)

Runs once before all examples in a group. Use this for expensive setup you only want to do once (rare in most specs).

```ruby
# /spec/hooks_spec.rb
RSpec.describe 'RecipeBox with before(:all)' do
  before(:all) do
    @shared_box = RecipeBox.new
    @shared_recipe = Recipe.new('Toast', ['bread', 'butter'])
    @shared_box.add_recipe(@shared_recipe)
  end

  it "shares state across examples" do
    expect(@shared_box.recipes).to include(@shared_recipe)
  end
end
```

### after

Runs after each example. Great for cleanup! Cleanup is important because it prevents side effects from one test affecting another. For example, if you create a file or open a database connection in one test, you want to make sure it’s closed or deleted before the next test runs. This keeps your test suite reliable and avoids mysterious bugs.

```ruby
# /spec/hooks_spec.rb
RSpec.describe RecipeBox do
  before(:each) do
    @box = RecipeBox.new
    @recipe = Recipe.new('Pancakes', ['flour', 'milk', 'egg'])
    @box.add_recipe(@recipe)
  end

  after(:each) do
    @box.clear
  end

  it "cleans up the RecipeBox after each example" do
    expect(@box.recipes.size).to eq(1)
  end
end
```

Run `rspec /spec/tempfile_spec.rb` to see how before and after hooks manage setup and cleanup.

## Instance Variables: Sharing Data Between Examples

Instance variables (like `@calculator`) let you share data between your setup and your examples. They’re available anywhere inside the `describe` or `context` block where you define them. This makes it easy to set up data once and use it in multiple tests, but it can sometimes make your tests less clear or introduce subtle bugs if you’re not careful.

In the next lesson, you’ll learn about `let` and `let!`, which improve on instance variables by making setup lazy (only created when needed) and making your specs even clearer and more maintainable.

### Bad Example: Repeating Yourself

```ruby
# /spec/hooks_spec.rb
RSpec.describe RecipeBox do
  it "adds a recipe (repeats setup)" do
    box = RecipeBox.new
    recipe = Recipe.new('Pancakes', ['flour', 'milk', 'egg'])
    box.add_recipe(recipe)
    expect(box.recipes).to include(recipe)
  end

  it "removes a recipe (repeats setup)" do
    box = RecipeBox.new
    recipe = Recipe.new('Pancakes', ['flour', 'milk', 'egg'])
    box.add_recipe(recipe)
    box.remove_recipe(recipe)
    expect(box.recipes).not_to include(recipe)
  end
end
```

### Good Example: Using before and @calculator

```ruby
# /spec/hooks_spec.rb
RSpec.describe RecipeBox do
  before(:each) do
    @box = RecipeBox.new
    @recipe = Recipe.new('Pancakes', ['flour', 'milk', 'egg'])
    @box.add_recipe(@recipe)
  end

  it "adds a recipe" do
    expect(@box.recipes).to include(@recipe)
  end

  it "removes a recipe" do
    @box.remove_recipe(@recipe)
    expect(@box.recipes).not_to include(@recipe)
  end
end
```

## When to Use before(:each) vs before(:all)

- Use `before(:each)` for most setup—each test gets a fresh start.
- Use `before(:all)` only for slow, expensive setup that doesn’t need to be reset between tests.
- Don’t use instance variables from `before(:all)` if you’re modifying them in tests (it can get weird and lead to unpredictable results). Try running a test where you change an instance variable set in `before(:all)` across multiple examples and see what happens!

Run `rspec spec/hooks_spec.rb` to see how before(:each) and after(:each) set up and clean up the test for every example.

## Getting Hands-On

You can fork and clone this lesson's repo, run the specs, and try implementing the two pending specs marked as student exercises in `spec/hooks_spec.rb`.

To get started:

```sh
git clone <your-fork-url>
cd rspec-before-after-hooks-and-instance-variables-readme
bundle install
bin/rspec
```

Look for the two pending specs (marked as 'Student exercise') and try to implement them yourself! All the examples use the RecipeBox and Recipe classes, so you can see real-world usage of before/after hooks and instance variables in a practical domain.

----

## Resources

- _Check the RSpec documentation for full details on hook types:_
  - [RSpec Hooks Documentation](https://relishapp.com/rspec/rspec-core/v/3-10/docs/hooks/before-and-after-hooks)
- _See best practices for DRY setup in specs:_
  - [Better Specs: DRY Setup](https://www.betterspecs.org/#before)
- _Learn more about Ruby instance variables:_
  - [Ruby Instance Variables](https://www.rubyguides.com/2019/01/ruby-instance-variables/)

_Next: You’ll learn about `let` and `let!`—even more ways to keep your specs clean and clear!_
