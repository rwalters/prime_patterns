class PrimeByStrategy
  attr_reader :number

  def initialize(number_to_test)
    @number = number_to_test
  end

  def is_prime?(strategy)
    return strategy.check(number)
  end
end
