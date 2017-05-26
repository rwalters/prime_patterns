module Strategies
  class LessThanTwo < Struct.new(:number)
    def not_prime?
      number < 2
    end
  end

  class IsEven < Struct.new(:number)
    def not_prime?
      number > 2 && number.even?
    end
  end

  class HasIntegerSquareRoot < Struct.new(:number)
    def not_prime?
      sqrt = Math.sqrt(number)
      sqrt == sqrt.floor
    end
  end

  class HasDivisor < Struct.new(:number)
    def not_prime?
      sqrt = Math.sqrt(number).floor
      (3...sqrt).any? do |i|
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
