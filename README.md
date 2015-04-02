# Software Design Patterns


I recently ran a small workshop about software [design patterns](http://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612), and I had a few examples for some of the most common patterns.  I felt pretty comfortable with the presentation overall, especially where I was able to use [a blog post](http://www.sandimetz.com/blog/2014/9/9/shape-at-the-bottom-of-all-things) by [Sandi Metz](http://www.sandimetz.com/) to illustrate the [Strategy Pattern](http://en.wikipedia.org/wiki/Strategy_pattern). Today I gave a presentation about [code katas](http://codekata.com/): what they are, how they are useful, when you might go over a kata, and showed a few examples. One of the katas that caught my eye today, from [CodeWars](http://www.codewars.com/), was about determining if a given number is prime.

Sandi's example about the rhyme was great, and I'm not going to attempt to improve upon it.  However, using something as simple as whether a number is prime can help make the underlying patterns all the more obvious.  By ridiculously over-engineering something simple, the mechanisms are laid bare and can then be transferred to more realistic, complicated situations.  I'll be using the excuse of discovering if a given number is prime to explore two patterns: the Strategy pattern mentioned earlier, and the [Chain of Responsibility](http://en.wikipedia.org/wiki/Chain-of-responsibility_pattern) pattern.

## Naive Prime Solution

I created a simple method of discovering if a number is a prime.  I just have a series of rules that perform a series of checks through guard clauses. For example, since 2 is prime, [I have a check to return true for that input](https://github.com/rwalters/prime_patterns/blob/master/lib/prime_naive.rb#L3), and since a prime number [has to be greater than 1](http://en.wikipedia.org/wiki/Prime_number), if an input is less than 2, [I return false](https://github.com/rwalters/prime_patterns/blob/master/lib/prime_naive.rb#L4). There are then other checks on what is not a prime before we just return true, since the input must be a prime at that point.

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
```

```ruby
  def is_prime?(input)
    return false if Strategies::LessThanTwo.new.check(input)
```

Since I had used tests to check the original version, it's easy to verify that this changes hasn't messed anything up by running those same tests. Unless there is some auto-loading going on, there will be a failure until `require 'strategies'` is added to the top of the file. Since it's quick, I'll move the next check into a separate strategy.  Now the code is

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

I created a new transitional file as to make these changes so they can be compared without having to dig through the history.

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

One way to make that strategy more consistent, and possibly more elegant, is by using `detect` instead of `each`. [Detect](http://ruby-doc.org/core-2.2.1/Enumerable.html#method-i-detect) passes each entry into the block to be tested however you wish, then either returns the first element for which the conditional is true, or else returns `nil`. I also [prepend `!!` to the detect](http://goo.gl/2rPcJH) to force the return into a strict boolean.

```ruby
  class HasDivisor
    def check(number)
      sqrt = Math.sqrt(number).floor
      return !!(3...sqrt).detect do |i|
        (number%i).zero?
      end
    end
  end
```
