# Software Design Patterns


I recently ran a small workshop about [software design patterns](http://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612), and I had a few examples for some of the most common patterns.  I felt pretty comfortable with the presentation overall, especially where I was able to use [a blog post](http://www.sandimetz.com/blog/2014/9/9/shape-at-the-bottom-of-all-things) by [Sandi Metz](http://www.sandimetz.com/) to illustrate the [Strategy Pattern](http://en.wikipedia.org/wiki/Strategy_pattern). Today I gave a presentation about [code katas](http://codekata.com/): what they are, how they are useful, when you might go over a kata, and showed a few examples. One of the katas that caught my eye today, from [CodeWars](http://www.codewars.com/), was about determining if a given number is prime.

Sandi's example about the rhyme was great, and I'm not going to attempt to improve upon it.  However, using something as simple as whether a number is prime can help make the underlying patterns all the more obvious.  By ridiculously over-engineering something simple, the mechanisms are laid bare and can then be transferred to more realistic, complicated situations.  I'll be using the excuse of discovering if a given number is prime to explore the Strategy pattern.

## Naive Prime Solution

I created a simple method of discovering if a number is a prime.  I just perform a series of checks using guard clauses. For example, since 2 is prime, [I have a check to return true for that input](https://github.com/rwalters/prime_patterns/blob/master/lib/prime_naive.rb#L3), and since a prime number [has to be greater than 1](http://en.wikipedia.org/wiki/Prime_number), if an input is less than 2, [I return false](https://github.com/rwalters/prime_patterns/blob/master/lib/prime_naive.rb#L4). There are then other checks on what is not a prime before we just return true, since the input must be a prime at that point.

```ruby
  def is_prime?(input)
    return true  if input == 2
    return false if input < 2
    return false if input.even?

    sqrt = Math.sqrt(input)
    return false if sqrt == sqrt.floor

    (3..(sqrt.floor)).each do |i|
      return false if (input%i).zero?
    end

    return true
  end
```

I used [TDD](http://en.wikipedia.org/wiki/Test-driven_development) to build even this simple solution. [The spec file](https://github.com/rwalters/prime_patterns/blob/master/spec/prime_naive_spec.rb) is straightforward, and has a lot of room for improvement to [DRY it up](http://en.wikipedia.org/wiki/Don%27t_repeat_yourself), but that can be an exercise for a different article.

## Strategy Pattern

With the naive solution now available, we can move those rules into individual strategies to be processed sequentially.  This will allow us to update the strategies or add new ones independently from the rest of the code.

Looking over the list of steps, something stands out. Each guard clause consists of a `return false if` statement, with a final `return true` to mark a number as prime after we've exhausted the checks for numbers that aren't prime.

Except, that is, for the first check on whether the input is 2.  If we remove that, a spec fails

```ruby
  context "for input of 2" do
    let(:input) { 2 }
    it { is_expected.to be_truthy }
  end
```

Which makes sense. We return false if the input is even: `return false if input.even?` We just change that, and the spec passes. So now we have the naive solution of

```ruby
  def is_prime?(input)
    return false if input < 2
    return false if input > 2 && input.even?

    sqrt = Math.sqrt(input)
    return false if sqrt == sqrt.floor

    (3..(sqrt.floor)).each do |i|
      return false if (input%i).zero?
    end

    return true
  end
```

Everything is consistent now, we return false if a given check is true, otherwise we move on to the next check.  I'm not comfortable returning false if a check is true, it could be confusing to a developer coming along in the future, but I'll shelve that concern for now. We can perhaps make this a little more obvious later with appropriate naming.

### Converting to a Strategy

We can start by moving the first check into a strategy, and calling it directly.

```ruby
module Strategies
  class LessThanTwo
    def check(number)
      return number < 2
    end
  end
end
```

```ruby
  def is_prime?(input)
    return false if Strategies::LessThanTwo.new.check(input)
```

Since I had used tests to check the original version, it's easy to verify that this change hasn't messed anything up by running those same tests. Unless there is some auto-loading going on, there will be a failure until `require 'strategies'` is added to the top of the file. Since it's quick, I'll move the next check into a separate strategy.  Now the code is

```ruby
module Strategies
  class LessThanTwo
    def check(number)
      return number < 2
    end
  end

  class IsEven
    def check(number)
      return number > 2 && number.even?
    end
  end
end
```

I created a new transitional file to make these changes so they can be compared without having to dig through the history.

```ruby
require 'strategies'

class PrimeTransition
  def is_prime?(input)
    return false if Strategies::LessThanTwo.new.check(input)
    return false if Strategies::IsEven.new.check(input)

    sqrt = Math.sqrt(input)
    return false if sqrt == sqrt.floor

    (3..(sqrt.floor)).each do |i|
      return false if (input%i).zero?
    end

    return true
  end
end
```

The next two checks aren't much more difficult than the last two, just moving each block of lines into a new strategy and converting the check into the familiar format of calling the new strategy.

```ruby
    return false if Strategies::HasIntegerSquareRoot.new.check(input)
    return false if Strategies::HasDivisor.new.check(input)
```

```ruby
  class HasIntegerSquareRoot
    def check(number)
      sqrt = Math.sqrt(number)
      return sqrt == sqrt.floor
    end
  end

  class HasDivisor
    def check(number)
      sqrt = Math.sqrt(number).floor
      (3..sqrt).each do |i|
        return true if (number%i).zero?
      end

      return false
    end
  end
```

All specs pass, but the last strategy is a little different. It returns true in the middle of the loop, then finishes up with returning false, where the other strategies just return a conditional.

One way to make that strategy more consistent, and possibly [more elegant](http://www.amazon.com/Eloquent-Ruby-Addison-Wesley-Professional-Series/dp/0321584104), is by using `any?` instead of `each`. [The `any?` method](http://ruby-doc.org/core-2.2.1/Enumerable.html#method-i-any-3F) passes each entry into the block to be tested however you wish, then returns `true` if at least one satisfies the conditional is true, or else returns `false` if every element fails the conditional.

```ruby
  class HasDivisor
    def check(number)
      sqrt = Math.sqrt(number).floor
      return (3...sqrt).any? do |i|
        (number%i).zero?
      end
    end
  end
```

We now have a tidy method, with all logic packaged up in discrete methods that are completely independent.

```ruby
  def is_prime?(input)
    return false if Strategies::LessThanTwo.new.check(input)
    return false if Strategies::IsEven.new.check(input)
    return false if Strategies::HasIntegerSquareRoot.new.check(input)
    return false if Strategies::HasDivisor.new.check(input)

    return true
  end
```

### Passing in Strategies

We won't have to touch the `is_prime?` method, or any of the other strategies, if one of the strategies is later found to be somehow lacking.  However, this isn't quite the "Strategy Pattern". What if we need to add a strategy? Or find we can remove one, for whatever reason? We would have to change this file, and add a new strategy to `lib/strategies.rb` (or wherever the strategies live). This isn't a big deal right now, just modifying two files, but if we were in actual code, we might be using these strategies in numerous places. Having them hardcoded each time would be inconvenient to maintain.

Instead, what if we passed these strategies in? In our contrived example, we can have `is_prime?` call a new [subordinate method](http://sourcemaking.com/refactoring/replace-method-with-method-object) and pass in the strategies that way.

```ruby
class PrimeByStrategy
  def is_prime?(input)
    strategies = [Strategies::LessThanTwo.new,
    Strategies::IsEven.new,
    Strategies::HasIntegerSquareRoot.new,
    Strategies::HasDivisor.new]

    return is_prime_by_strategy?(input, strategies)
  end

  def is_prime_by_strategy?(number, strategies = [])
    return false if strategies.any?{|s| s.check(number)}
    return true
  end
end
```

I'm still not happy with assembling the strategies right here. We have the logic of each of the strategies in the Strategies module, why not move the list of prime strategies there, too?

```ruby
module Strategies
  PRIME_STRATEGIES = [Strategies::LessThanTwo,
                      Strategies::IsEven,
                      Strategies::HasIntegerSquareRoot,
                      Strategies::HasDivisor]
```

And then we can just call on that, and if we add or remove strategies later, our `PrimeByStrategy` doesn't care.

```ruby
class PrimeByStrategy
  def is_prime?(input)
    return is_prime_by_strategy?(input, Strategies::PRIME_STRATEGIES.map(&:new))
  end

  def is_prime_by_strategy?(number, strategies = [])
    return false if strategies.any?{|s| s.check(number)}
    return true
  end
end
```

This is looking better, but it seems a little odd to have that one line in the `is_prime?` method. We can push those methods back together again, and make the `PRIME_STRATEGIES` constant the default for the method.

```ruby
class PrimeByStrategy
  def is_prime?(input, strategies = Strategies::PRIME_STRATEGIES.map(&:new))
    return false if strategies.any?{|s| s.check(input)}
    return true
  end
end
```

## Epilogue

At this point, we're done showing off the strategy pattern. There is just one little thing that has been bothering me. We call `check` on the strategies, but get back a boolean.  I even modified the `HasDivisor` strategy to make sure it explicitly returned a boolean.  In Ruby, we can mark methods that pass back booleans by putting a question mark on the end. We could drop a `?` on there and leave it as `check?`, but giving it a bit more thought, it might be better to make it overall more descriptive.

```ruby
  class LessThanTwo
    def not_prime?(number)
      return number < 2
    end
  end
```

And call it from `is_prime?`

```ruby
  def is_prime?(input, strategies = Strategies::PRIME_STRATEGIES.map(&:new))
    return false if strategies.any?{|s| s.not_prime?(input)}
    return true
  end
```

We could keep going on other points, such as why I made each strategy a class that is instantiated instead of just using class methods that would be called directly, but perhaps I can go over that in another article.
