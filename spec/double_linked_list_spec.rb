require 'spec_helper'
describe DoubleLinkedList do
  let(:users_ary) do
    [
      Contextuable.new(id: 1),
      Contextuable.new(id: 2),
      Contextuable.new(id: 3)
    ]
  end

  class CustomDLL < DoubleLinkedList; end

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
    describe '#find_by' do
      it { expect(subject.find_by{ |elem| elem.datum == 2 }.datum).to eq 2 }
      it { expect(subject.find_by{ |elem| elem.datum == 3 }.datum).to eq 3 }
      it { expect(subject.find_by{ |elem| elem.datum == 9 }).to be_nil }
      context 'complex elements' do
        subject { described_class.from_a(users_ary) }
        it { expect(subject.find_by{ |elem| elem.datum.id == 3 }.datum.id).to eq 3 }
        it { expect(subject.find_by{ |elem| elem.datum.id == 2 }.datum.id).to eq 2 }
        it { expect(subject.find_by{ |elem| elem.datum.id == 4 }).to be_nil }
      end
    end
    describe '#reverse_find' do
      it { expect(subject.reverse_find(2).datum).to eq 2 }
      it { expect(subject.reverse_find(9)).to be_nil }
    end
    describe '#reverse_find_by' do
      it { expect(subject.reverse_find_by{ |elem| elem.datum == 2 }.datum).to eq 2 }
      it { expect(subject.reverse_find_by{ |elem| elem.datum == 9 }).to be_nil }
      context 'complex elements' do
        subject { described_class.from_a(users_ary) }
        it { expect(subject.reverse_find_by{ |elem| elem.datum.id == 3 }.datum.id).to eq 3 }
      end
    end

    describe '#last' do
      it { expect(subject.last).to eq subject.find(3) }
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

    describe '#to_a' do
      it { expect(subject.to_a).to eq [1, 2, 3]}
    end

    it 'chunk_by' do
      chunked = subject.chunk_by do |e, current_llist|
        e.datum == 3 && current_llist.head.datum == 1
      end
      expect(chunked.count).to eq 2
      expect(chunked.first).to be_a DoubleLinkedList
      expect(chunked.first.to_a).to eq [1, 2]
      expect(chunked.last.to_a).to eq [3]
    end

    it 'chunk_by with custom dll' do
      chunked = subject.chunk_by(CustomDLL) do |e, current_llist|
        e.datum == 3 && current_llist.head.datum == 1
      end
      expect(chunked.count).to eq 2
      expect(chunked.all?{|e| e.is_a?(CustomDLL)}).to be true
      expect(chunked.first.to_a).to eq [1, 2]
      expect(chunked.last.to_a).to eq [3]
    end

    it 'select_by' do
      select = subject.select_by do |e|
        if e.datum == 2 && e.next.datum == 3
          DoubleLinkedList::Sequence.new(head: e, last: e.next)
        end
      end
      expect(select.count).to eq 1
      expect(select.first).to be_a DoubleLinkedList
      expect(select.first.to_a).to eq [2, 3]
    end

    it 'count' do
      expect(subject.count).to eq 3
    end

  end
end
