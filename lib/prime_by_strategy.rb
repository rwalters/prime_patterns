require_relative 'strategies'

class PrimeByStrategy
  def is_prime?(input)
    !Strategies::PRIME_STRATEGIES.map { |strategy| strategy.new(input) }
    .any?(&:not_prime?)
  end
end
