module Processors
  class LessThanTwo
    def not_prime?(number)
      if number < 2
        true
      else
        successor.not_prime?(number)
      end
    end

    def successor
      Default.new
    end
  end

  class Default
    def not_prime?(number)
      false
    end
  end
end
