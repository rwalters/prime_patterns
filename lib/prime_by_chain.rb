require 'processors'

class PrimeByChain
  def is_prime?(input)
    return false if Processors::LessThanTwo.new.not_prime?(input)

    sqrt = Math.sqrt(input)
    return false if sqrt == sqrt.floor

    (3..(sqrt.floor)).each do |i|
      return false if (input%i).zero?
    end

    return true
  end
end
