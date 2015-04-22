# Software Design Patterns

This is the second article in a series on software design patterns, continuing from [an article](https://github.com/rwalters/prime_patterns/blob/master/strategy_pattern.md) covering the [Strategy Pattern](http://en.wikipedia.org/wiki/Strategy_pattern). This time, I'll be going over something called the [Chain of Responsibility](http://en.wikipedia.org/wiki/Chain-of-responsibility_pattern).

## Is This a Prime Number

I used a very simple [kata](http://www.codewars.com/) to explain the strategy pattern, and I'll use that same prime kata to illustrate an implementation of the Chain of Responsibility. The [naive solution](https://github.com/rwalters/prime_patterns/blob/master/lib/prime_naive.rb) I created determines whether a number is prime using a series of rules testing if a given number is _not_ prime.

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

Each rule checks if a number is not prime, so if the check is `true`, we return `false`, the number being tested is not prime. If all rules are false, we are left with a prime number.

## Chain of Responsibility Pattern
