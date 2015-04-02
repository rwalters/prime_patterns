module Strategies
  class LessThanTwo
    def not_prime?(number)
      return number < 2
    end
  end

  class IsEven
    def not_prime?(number)
      return number > 2 && number.even?
    end
  end

  class HasIntegerSquareRoot
    def not_prime?(number)
      sqrt = Math.sqrt(number)
      return sqrt == sqrt.floor
    end
  end

  class HasDivisor
    def not_prime?(number)
      sqrt = Math.sqrt(number).floor
      return !!(3...sqrt).detect do |i|
        (number%i).zero?
      end
    end
  end

  PRIME_STRATEGIES =
    [Strategies::LessThanTwo,
     Strategies::IsEven,
     Strategies::HasIntegerSquareRoot,
     Strategies::HasDivisor]
end
