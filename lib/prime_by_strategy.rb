require 'strategies'

class PrimeByStrategy
  def is_prime?(input, strategies = Strategies::PRIME_STRATEGIES.map(&:new))
    return false if strategies.any?{|s| s.check(input)}
    return true
  end
end
