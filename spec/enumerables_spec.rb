require 'spec_helper'
describe DoubleLinkedList do
  describe 'reduce' do
    it do
      sum = described_class.from_a(1, 2, 3).reduce(0) do |prev, _next|
          prev + _next.datum
      end
      expect(sum).to eq 6
    end
  end
  describe 'to_a' do
    it do
      input = [1, 2, 3]
      llist = described_class.from_a(input)
      expect(llist.to_a).to eq input
    end
  end

  describe 'chunck_by' do
    it do
      out = described_class.from_a(1, 2, 3).chunk_by do |e|
        if e.prev
          e.prev.datum % 2 == 0
        end
      end
      expect(out.count).to eq(2)
      expect(out.first.head.datum).to eq(1)
      expect(out.first.last.datum).to eq(2)
      expect(out.last.head.datum).to eq(3)
      expect(out.last.last.next).to be_nil
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
