# Software Design Patterns

This is the second article in a series on software design patterns, continuing from [my first article](https://github.com/rwalters/prime_patterns/blob/master/strategy_pattern.md) covering the [Strategy Pattern](http://en.wikipedia.org/wiki/Strategy_pattern). This time, I'll be going over something called the [Chain of Responsibility](http://en.wikipedia.org/wiki/Chain-of-responsibility_pattern).

## A Simple Example

I used a very simple [kata](http://www.codewars.com/) to explain the strategy pattern, and I'll use that same prime kata to illustrate an implementation of the Chain of Responsibility Pattern. The [naive solution](https://github.com/rwalters/prime_patterns/blob/master/lib/prime_naive.rb) I created determines whether a number is prime using a series of rules testing if a given number is _not_ prime.

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

Each rule checks if the input is not prime, so if the check is `true` then the number being tested is not prime and we return `false`. If all rules are false, we are left with a prime number.

## Chain of Responsibility Pattern

In my [previous article](https://github.com/rwalters/prime_patterns/blob/master/strategy_pattern.md), I showed how to move these sequential checks into an array of strategies that we could use as part of the Strategy Pattern. This time, I will use these to implement a form of the Chain of Responsibility pattern.

Instead of calling these "strategies", we will call them "processors". And, rather than handle an array of these processors up front, we will let each one handle the decision. Each processor will either know the answer, or pass the decision on to another object to make the decision. In this way, we can potentially have a complex tree of decisions our program will make to determine an answer, much more flexible and powerful than a straight array of strategies to be applied.

This is absolute overkill for our example, of course, and we will end up with a linear path of decisions, but this will allow us to explore the concepts in this pattern without having to actually deal with a whole tree of decisions.

## Converting to a Chain of Responsibility

We'll start with our naive solution, then move each check into a `Processor` class, and call that new object to perform the check. As we add each check to a processor, we'll have the last processor hand off the decision to the new object.

The starting point is the same as the code we started with on our exploration of the Strategy Pattern.

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

The first check is whether the input is less than two. But where do we move that?

### Processor Classes

We need something to hold the check, and also hold a pointer on to the next `Processor` along with logic on when to pass the decision along in the chain.

The first pass looks almost identical to our first [Strategy](https://github.com/rwalters/prime_patterns/blob/master/lib/strategies.rb#L2):

```ruby
module Processors
  class LessThanTwo
    def not_prime?(number)
      return number < 2
    end
  end
end
```

#### LessThanTwo

However, this doesn't have any logic on when to pass the decision along in the chain, nor any way to specify a successor. We can add the logic to `not_prime?`, just sort of guessing at what we need at the moment and waiting for specifics if the need should arise:

```ruby
    def not_prime?(number)
      if number < 2
        true
      else
        successor.not_prime?(number)
      end
    end
```

It looks like we need a `successor` of some sort, perhaps a variable that holds a `Processor` object. Even better, we can make it a method we can call that will determine the `Processor` we need, and return an instance of it for us to use:

```ruby
    def successor
      nil
    end
```

We don't actually want to return `nil`, that would just throw an error when we try to call `not_prime?` on it. We could add a test to see if our successor is `nil`, and return false if that's the case:

```ruby
    def not_prime?(number)
      if number < 2
        true
      else
        return successor.not_prime?(number) unless sucessor.nil?
        false
      end
    end
```

But that `unless` inside an `if` just doesn't look right. Instead of nesting `if`-s and `unless`-s, let's create a default `Processor` that just returns false for `not_prime?`:

```ruby
module Processors
  class LessThanTwo
    def not_prime?(number)
      if number < 2
        true
      else
        successor.not_prime?(number)
      end
    end

    def successor
      Default.new
    end
  end

  class Default
    def not_prime?(number)
      false
    end
  end
end
```

Now, we'll call that just like we called the Strategy before:

```ruby
require 'processors'

class PrimeByChain
  def is_prime?(input)
    return false if Processors::LessThanTwo.new.not_prime?(input)
    return false if input > 2 && input.even?
```

This passes our tests without a complaint, so we move on to the next check:

#### IsEven

```ruby
  class IsEven
    def not_prime?(number)
      if input > 2 && input.even?
        true
      else
        successor.not_prime?(number)
      end
    end

    def successor
      Default.new
    end
  end
```

We will use `Default` as the successor on `IsEven`, and then use `IsEven` in the `successor` for `LessThanTwo`:

```ruby
  class LessThanTwo
    def successor
      Processors::IsEven.new
    end
  end
```

Next, instead of changing `return false if input > 2 && input.even?` to use `Processors::IsEven`, we just remove the line:

```ruby
class PrimeByChain
  def is_prime?(input)
    return false if Processors::LessThanTwo.new.not_prime?(input)

    sqrt = Math.sqrt(input)
    return false if sqrt == sqrt.floor
```

Our tests pass, since the `LessThanTwo` processor passes responsibility on to `IsEven` all on its own.

## Finishing Up

We repeat these steps until we end up with only two lines in `is_prime?`:

```ruby
class PrimeByChain
  def is_prime?(input)
    return false if Processors::LessThanTwo.new.not_prime?(input)

    return true
  end
end
```

We move the last two checks into their own `Processor` classes, and update the `successor` for `IsEven`:

```ruby
module Processors
  class IsEven
    def successor
      Processors::HasSquareRoot.new
    end
  end

  class HasSquareRoot
    def not_prime?(number)
      sqrt = Math.sqrt(number)
      if sqrt == sqrt.floor
        true
      else
        successor.not_prime?(number)
      end
    end

    def successor
      Processors::HasIntegerDivisor.new
    end
  end

  class HasIntegerDivisor
    def not_prime?(number)
      if divisor_found(number)
        true
      else
        successor.not_prime?(number)
      end
    end

    def successor
      Default.new
    end

    private

    def divisor_found(number)
      sqrt = Math.sqrt(number)
      (3...sqrt).any? do |i|
        (number%i).zero?
      end
    end
  end

  class Default
    def not_prime?(number)
      false
    end
  end
end
```

One thing I want to note here is the addition of the private method `def divisor_found?` to `HasIntegerDivisor`. I wanted to keep the flow going, and line count down, in the primary `not_prime?` method, so I moved the `any?` check down out of the way.

## Epilogue

At the end of the article on the Strategy pattern, we were also left with just two lines in our `is_prime?` method, which may make it look very similar to the Chain of Responsibility we just went over here. The two biggest differences I wanted to highlight here both involve increased flexibility.

First, we can add and remove `Processors` on the fly. If we had a range of `Processor` classes from which to choose, and the `successor` pulled from a database, we wouldn't need to change a single line of code to swap out processor objects.

Second, we can put logic in the `successor` method to branch out in a way we weren't easily able to in the Strategy pattern. This relates to the first point, being able to swap on the fly, so that we can even loop back to an earlier `Processor` and take a different branch.

Unfortunately, this can lend to dense complexity in unraveling the steps involved in a particular decision. This can be ameliorated by logging or some form of [a chain of custody](http://en.wikipedia.org/wiki/Chain_of_custody), but is still a factor to consider when looking to apply this pattern.
