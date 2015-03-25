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

  class HasIntegerSquareRoot
    def check(number)
      sqrt = Math.sqrt(number)
      return sqrt == sqrt.floor
    end
  end

  class HasDivisor
    def check(number)
      sqrt = Math.sqrt(number).floor
      return !!(3...sqrt).detect do |i|
        (number%i).zero?
      end
    end
  end
end
