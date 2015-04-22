# Software Design Patterns

this is the second article in a series on software design patterns, [the first](https://github.com/rwalters/prime_patterns/blob/master/strategy_pattern.md) covering the [Strategy Pattern](http://en.wikipedia.org/wiki/Strategy_pattern). This time, I'll be going over something called the [Chain of Responsibility](http://en.wikipedia.org/wiki/Chain-of-responsibility_pattern).

As I previously covered, I created a simple method of determining if a number is prime using a series of rules.

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
