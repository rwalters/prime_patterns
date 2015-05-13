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
      Processors::IsEven.new
    end
  end

  class IsEven
    def not_prime?(number)
      if number > 2 && number.even?
        true
      else
        successor.not_prime?(number)
      end
    end

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
      if divisor_found?(number)
        true
      else
        successor.not_prime?(number)
      end
    end

    def successor
      Default.new
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
end
