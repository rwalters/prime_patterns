require 'strategies'

class PrimeTransition
  def is_prime?(input)
    return false if Strategies::LessThanTwo.new.not_prime?(input)
    return false if Strategies::IsEven.new.not_prime?(input)
    return false if Strategies::HasIntegerSquareRoot.new.not_prime?(input)
    return false if Strategies::HasDivisor.new.not_prime?(input)

    return true
  end
end
