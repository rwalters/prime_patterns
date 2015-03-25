require 'strategies'

class PrimeTransition
  def is_prime?(input)
    return false if Strategies::LessThanTwo.new.check(input)
    return false if Strategies::IsEven.new.check(input)
    return false if Strategies::HasIntegerSquareRoot.new.check(input)
    return false if Strategies::HasDivisor.new.check(input)

    return true
  end
end
