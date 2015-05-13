require 'processors'

class PrimeByChain
  def is_prime?(input)
    return false if Processors::LessThanTwo.new.not_prime?(input)

    return true
  end
end
