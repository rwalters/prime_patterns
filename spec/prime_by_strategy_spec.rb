require 'prime_by_strategy'
require 'strategies'

describe PrimeByStrategy do
  context "for each strategy" do
    subject{ described_class.new(input).is_prime?(strategy) }

    context "LessThanTwo" do
      let(:strategy) { Strategies::LessThanTwo.new }

      context "input of 1" do
        let(:input) { 1 }

        it "returns false" do
          expect(subject).to eq false
        end
      end

      context "input of -1" do
        let(:input) { -1 }

        it "returns false" do
          expect(subject).to eq false
        end
      end

      context "input of 2" do
        let(:input) { 2 }

        it "returns true" do
          expect(subject).to eq true
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

    context "IsEven" do
      let(:strategy) { Strategies::IsEven.new }

      context "input of 1" do
        let(:input) { 1 }

        it "returns true" do
          expect(subject).to eq true
        end
      end

      context "input of 2" do
        let(:input) { 2 }

        it "returns true" do
          expect(subject).to eq true
        end
      end

      context "input of 8" do
        let(:input) { 8 }

        it "returns false" do
          expect(subject).to eq false
        end
      end

      context "input of 33" do
        let(:input) { 33 }

        it "returns true" do
          expect(subject).to eq true
        end
      end

      context "input of 34" do
        let(:input) { 34 }

        it "returns false" do
          expect(subject).to eq false
        end
      end
    end
  end
end
