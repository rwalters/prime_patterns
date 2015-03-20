class PrimeByStrategy
  attr_reader :number

  def initialize(number_to_test)
    @number = number_to_test
  end

  def is_prime?(strategy)
    return false if strategy.check(number)
    return true
  end
end
