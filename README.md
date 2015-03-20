# Software Design Patterns


I recently ran a small workshop about software [design patterns](http://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612), and I had a few examples for some of the most common patterns.  I felt pretty comfortable with the presentation overall, especially where I was able to use [a blog post](http://www.sandimetz.com/blog/2014/9/9/shape-at-the-bottom-of-all-things) by [Sandi Metz](http://www.sandimetz.com/) to illustrate the [Strategy Pattern](http://en.wikipedia.org/wiki/Strategy_pattern). Today I gave a presentation about [code katas](http://codekata.com/): what they are, how they are useful, when you might go over a kata, and showed a few examples. One of the katas that caught my eye today, from [CodeWars](http://www.codewars.com/), was about determining if a given number is prime.

Sandi's example about the rhyme was great, and I'm not going to attempt to improve upon it.  However, using something as simple as whether a number is prime can help make the underlying patterns all the more obvious.  By ridiculously over-engineering something simple, the mechanisms are laid bare and can then be transferred to more realistic, complicated situations.  I'll be using the excuse of discovering if a given number is prime to explore two patterns: the Strategy pattern mentioned earlier, and the [Chain of Responsibility](http://en.wikipedia.org/wiki/Chain-of-responsibility_pattern) pattern.

## Naive Prime Solution

I created a simple method of discovering if a number is a prime.  I just have a series of rules that perform a series of checks through guard clauses. For example, since [a prime number is greater than 1](http://en.wikipedia.org/wiki/Prime_number), if an input is less than 2, [I return false](https://github.com/rwalters/prime_patterns/blob/master/lib/prime_naive.rb#L4). Similarly, since 2 is prime, [I have a check to return true for that input](https://github.com/rwalters/prime_patterns/blob/master/lib/prime_naive.rb#L3).

```
  def is_prime?(input)
    return true if input == 2
    return false if input < 2
```

I used [TDD](http://en.wikipedia.org/wiki/Test-driven_development) to build even this simple solution. [The spec file](https://github.com/rwalters/prime_patterns/blob/master/spec/prime_naive_spec.rb) is straightforward, and has a lot of room for improvement to [DRY it up](http://en.wikipedia.org/wiki/Don%27t_repeat_yourself), but that can be an exercise for a different article.

## Strategy Pattern

With the naive solution now available, we can move those rules into individual strategies we can go through in a sequence.  This will allow us to update the strategies independently from the rest of the code.
