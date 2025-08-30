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
# /spec/calculator_spec.rb
RSpec.describe Calculator do
  before(:each) do
    @calculator = Calculator.new
  end

  it "adds numbers" do
    expect(@calculator.add(2, 3)).to eq(5)
  end

  it "subtracts numbers" do
    expect(@calculator.subtract(5, 2)).to eq(3)
  end
end
```

### before(:all)

Runs once before all examples in a group. Use this for expensive setup you only want to do once (rare in most specs).

```ruby
# /spec/database_spec.rb
RSpec.describe Database do
  before(:all) do
    @db = Database.connect
  end

  it "can find a user" do
    expect(@db.find_user("alice")).not_to be_nil
  end
end
```

### after

Runs after each example. Great for cleanup! Cleanup is important because it prevents side effects from one test affecting another. For example, if you create a file or open a database connection in one test, you want to make sure it’s closed or deleted before the next test runs. This keeps your test suite reliable and avoids mysterious bugs.

```ruby
# /spec/tempfile_spec.rb
RSpec.describe Tempfile do
  before(:each) do
    @file = Tempfile.new("test.txt")
  end

  after(:each) do
    @file.close
    @file.unlink
  end

  it "writes to a file" do
    @file.write("hello")
    @file.rewind
    expect(@file.read).to eq("hello")
  end
end
```

Run `rspec /spec/tempfile_spec.rb` to see how before and after hooks manage setup and cleanup.

## Instance Variables: Sharing Data Between Examples

Instance variables (like `@calculator`) let you share data between your setup and your examples. They’re available anywhere inside the `describe` or `context` block where you define them. This makes it easy to set up data once and use it in multiple tests, but it can sometimes make your tests less clear or introduce subtle bugs if you’re not careful.

In the next lesson, you’ll learn about `let` and `let!`, which improve on instance variables by making setup lazy (only created when needed) and making your specs even clearer and more maintainable.

### Bad Example: Repeating Yourself

```ruby
# /spec/calculator_spec.rb
RSpec.describe Calculator do
  it "adds numbers" do
    calculator = Calculator.new
    expect(calculator.add(2, 3)).to eq(5)
  end

  it "subtracts numbers" do
    calculator = Calculator.new
    expect(calculator.subtract(5, 2)).to eq(3)
  end
end
```

### Good Example: Using before and @calculator

```ruby
# /spec/calculator_spec.rb
RSpec.describe Calculator do
  before(:each) do
    @calculator = Calculator.new
  end

  it "adds numbers" do
    expect(@calculator.add(2, 3)).to eq(5)
  end

  it "subtracts numbers" do
    expect(@calculator.subtract(5, 2)).to eq(3)
  end
end
```

## When to Use before(:each) vs before(:all)

- Use `before(:each)` for most setup—each test gets a fresh start.
- Use `before(:all)` only for slow, expensive setup that doesn’t need to be reset between tests.
- Don’t use instance variables from `before(:all)` if you’re modifying them in tests (it can get weird and lead to unpredictable results). Try running a test where you change an instance variable set in `before(:all)` across multiple examples and see what happens!

Run `rspec /spec/calculator_spec.rb` to see how before(:each) sets up the test for every example.

## Practice Prompts

Try these exercises to reinforce your learning. For each, write your own spec in the appropriate file (e.g., `/spec/calculator_spec.rb` or `/spec/tempfile_spec.rb`).

**Exercise 1: Refactor repeated setup**
Refactor a spec that repeats setup code to use `before(:each)` and instance variables.

**Exercise 2: Explore before(:all) behavior**
Try using `before(:all)` and see what happens if you change the variable in a test. What do you notice?

**Exercise 3: Add cleanup with after(:each)**
Add an `after(:each)` hook to clean up a resource (like a file or database connection). Why is cleanup important?

**Exercise 4: Predict before(:all) variable modification**
Predict what will happen if an instance variable set in `before(:all)` is modified in multiple tests. Then try it and observe the results.

**Exercise 5: Why DRY?**
Why is DRY code easier to maintain? Write your answer in your own words.

---

## Resources

- _Check the RSpec documentation for full details on hook types:_
  - [RSpec Hooks Documentation](https://relishapp.com/rspec/rspec-core/v/3-10/docs/hooks/before-and-after-hooks)
- _See best practices for DRY setup in specs:_
  - [Better Specs: DRY Setup](https://www.betterspecs.org/#before)
- _Learn more about Ruby instance variables:_
  - [Ruby Instance Variables](https://www.rubyguides.com/2019/01/ruby-instance-variables/)

_Next: You’ll learn about `let` and `let!`—even more ways to keep your specs clean and clear!_
