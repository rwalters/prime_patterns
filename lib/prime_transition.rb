require 'strategies'

class PrimeTransition
  def is_prime?(input)
    return false if Strategies::LessThanTwo.new.check(input)
    return false if Strategies::IsEven.new.check(input)
    return false if Strategies::HasIntegerSquareRoot.new.check(input)

    sqrt = Math.sqrt(input)
    (3..(sqrt.floor)).each do |i|
      return false if (input%i).zero?
    end

    return true
  end
end
