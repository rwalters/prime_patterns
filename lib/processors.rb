module Processors

  class AbstractProcessor
    def successor
      EXECUTION_PLAN.fetch(self.class).call
    end
  end

  class LessThanTwo < AbstractProcessor
    def not_prime?(number)
      if number < 2
        true
      else
        successor.not_prime?(number)
      end
    end
  end

  MAIN = LessThanTwo

  class IsEven < AbstractProcessor
    def not_prime?(number)
      if number > 2 && number.even?
        true
      else
        successor.not_prime?(number)
      end
    end
  end

  class HasSquareRoot < AbstractProcessor
    def not_prime?(number)
      sqrt = Math.sqrt(number)
      if sqrt == sqrt.floor
        true
      else
        successor.not_prime?(number)
      end
    end
  end

  class HasIntegerDivisor < AbstractProcessor
    def not_prime?(number)
      if divisor_found?(number)
        true
      else
        successor.not_prime?(number)
      end
    end

    private

    def divisor_found?(number)
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

  EXECUTION_PLAN = {
    LessThanTwo       => -> do
      IsEven.new
    end,

    IsEven            => -> do
      Processors::HasSquareRoot.new
    end,

    HasSquareRoot     => -> do
      Processors::HasIntegerDivisor.new
    end,

    HasIntegerDivisor => -> do
      Default.new
    end,
  }

end
