require 'prime_naive'

describe PrimeNaive do
  subject { described_class.new.is_prime?(input) }

  context "for input of 2" do
    let(:input) { 2 }
    it { is_expected.to be_truthy }
  end

  context "non-primes" do
    context "for input of less than 2" do
      let(:input) { 1 }
      it { is_expected.to be_falsey }
    end

    context "for input that is even" do
      context "4" do
        let(:input) { 4 }
        it { is_expected.to be_falsey }
      end

      context "18" do
        let(:input) { 18}
        it { is_expected.to be_falsey }
      end

      context "86" do
        let(:input) { 86 }
        it { is_expected.to be_falsey }
      end
    end

    context "for input that is a non-even square" do
      context "9" do
        let(:input) { 9 }
        it { is_expected.to be_falsey }
      end

      context "25" do
        let(:input) { 25 }
        it { is_expected.to be_falsey }
      end

      context "81" do
        let(:input) { 81 }
        it { is_expected.to be_falsey }
      end
    end

    context "for input of 21" do
      let(:input) { 21 }
      it { is_expected.to be_falsey }
    end
  end

  context "for primes" do
    context "for input of 29" do
      let(:input) { 29 }
      it { is_expected.to be_truthy }
    end

    context "for input of 79" do
      let(:input) { 79 }
      it { is_expected.to be_truthy }
    end

    context "for input of 953" do
      let(:input) { 953 }
      it { is_expected.to be_truthy }
    end

    context "for input of 2309" do
      let(:input) { 2309 }
      it { is_expected.to be_truthy }
    end
  end
end
