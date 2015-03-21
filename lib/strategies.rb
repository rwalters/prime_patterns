module Strategies
  class LessThanTwo
    def check(number)
      return number < 2
    end
  end

  class IsEven
    def check(number)
      return number > 2 && number.even?
    end
  end
end
