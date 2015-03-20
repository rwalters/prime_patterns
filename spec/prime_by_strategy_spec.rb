require 'prime_by_strategy'
require 'strategies'

describe PrimeByStrategy do
  context "for each strategy" do
    subject{ described_class.new(input).is_prime?(strategy) }

    context "IsTwo" do
      let(:strategy) { Strategies::IsTwo.new }

      context "input of 2" do
        let(:input) { 2 }

        it "returns false" do
          expect(subject).to eq false
        end
      end

      context "input of 3" do
        let(:input) { 3 }

        it "returns true" do
          expect(subject).to eq true
        end
      end

      context "input of 33" do
        let(:input) { 33 }

        it "returns true" do
          expect(subject).to eq true
        end
      end
    end
  end
end
