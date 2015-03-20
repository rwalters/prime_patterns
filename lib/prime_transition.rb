require 'prime_by_strategy'
require 'strategies'

class PrimeTransition
  def is_prime?(input)
    return false if PrimeByStrategy.new(input).is_prime?(Strategies::LessThanTwo.new)
    return false if PrimeByStrategy.new(input).is_prime?(Strategies::IsEven.new)

    sqrt = Math.sqrt(input)
    return false if sqrt == sqrt.floor

    (3..(sqrt.floor)).each do |i|
      return false if (input%i).zero?
    end

    return true
  end
end
