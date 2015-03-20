class PrimeNaive
  def is_prime?(input)
    return true if input == 2
    return false if input < 2
    return false if input.even?

    sqrt = Math.sqrt(input)
    return false if sqrt == sqrt.floor

    (3..(sqrt.floor)).each do |i|
      return false if (input%i).zero?
    end

    return true
  end
end
