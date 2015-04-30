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
