require 'spec_helper'
describe DoubleLinkedList do
  describe 'initial state' do
    subject { described_class.new(:head) }
    it { expect(subject.head.datum).to eq :head }
    it { expect(subject.head.next).to be_nil }
    describe '#find' do
      it { expect(subject.find(:head).datum).to eq(:head) }
    end
  end

  describe "::from_a" do
    subject { described_class.from_a(1, 2, 3) }
    it { expect(subject.datum).to eq 1 }
    it { expect(subject.next.datum).to eq 2 }
    it { expect(subject.next.next.datum).to eq 3 }
    it { expect(subject.next.next.next).to be_nil }

    describe '#find' do
      it { expect(subject.find(2).datum).to eq 2 }
      it { expect(subject.find(3).datum).to eq 3 }
      it { expect(subject.find(9)).to be_nil }
    end

    describe '#last' do
      it { expect(subject.last).to eq subject.find(3) }
    end

    describe '#find_previous' do
      it { expect(subject.find_previous(3).datum).to eq 2 }
      it { expect(subject.find_previous(2).datum).to eq 1 }
      it { expect(subject.find_previous(1)).to be_nil }
    end
    describe '#previous' do
      it { expect(subject.find(3).previous.datum).to eq 2 }
      it { expect(subject.find(2).previous.datum).to eq 1 }
      it { expect(subject.find(1).previous).to be_nil }
    end
    describe '#prev' do
      it { expect(subject.find(3).prev.datum).to eq 2 }
      it { expect(subject.find(2).prev.datum).to eq 1 }
      it { expect(subject.find(1).prev).to be_nil }
    end

    describe '#append' do
      before { subject.append(4) }
      it { expect(subject.last.datum).to eq 4 }
      it { expect(subject.last.next).to be_nil }
      it { expect(subject.last.previous.datum).to eq 3 }
    end

  end
  describe '#reverse_each' do
    subject do
      data = []
      described_class.from_a(1, 2, 3).reverse_each{ |d| data << d.datum}
      data
    end
    it do
      expect(subject).to eq [3, 2, 1]
    end
  end
  describe '#each' do
    subject do
      data = []
      described_class.from_a(1, 2, 3).each{ |d| data << d.datum}
      data
    end
    it do
      expect(subject).to eq [1, 2, 3]
    end
  end
end
