require 'strategies'

class PrimeByStrategy
  def is_prime?(input, strategies = Strategies::PRIME_STRATEGIES.map(&:new))
    return false if strategies.any?{|s| s.not_prime?(input)}
    return true
  end
end
