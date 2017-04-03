require 'spec_helper'

describe DoubleLinkedList::Element do
  let(:list){ DoubleLinkedList.from_a(1, 2, 3, 4) }
  it '#find_previous_by' do
    three = list.find(3)
    zero = three.find_previous_by { |e| e.datum  == 0 }
    two = three.find_previous_by { |e| e.datum  == 2 }
    one = three.find_previous_by { |e| e.datum  == 1 }
    four = three.find_previous_by { |e| e.datum  == 4 }
    expect(two.datum).to eq 2
    expect(one.datum).to eq 1
    expect(zero).to be_nil
    expect(four).to be_nil
  end

  it '#find_next_by' do
    two = list.find(2)
    zero = two.find_next_by { |e| e.datum  == 0 }
    three = two.find_next_by { |e| e.datum  == 3 }
    one = two.find_next_by { |e| e.datum  == 1 }
    four = two.find_next_by { |e| e.datum  == 4 }
    expect(one).to be_nil
    expect(zero).to be_nil
    expect(four.datum).to eq(4)
    expect(three.datum).to eq(3)
  end
  it '#find' do
    expect(list.head.find(2).datum).to eq 2
  end

  it 'chunk_by' do
    chunked = list.head.chunk_by([]) do |e, current_llist|
      e.datum == 3 && current_llist.head.datum == 1
    end
    expect(chunked.count).to eq 2
    expect(chunked.first).to be_a DoubleLinkedList
    expect(chunked.first.to_a).to eq [1, 2]
    expect(chunked.last.to_a).to eq [3, 4]
  end

  it 'select_by' do
    select = list.head.select_by do |e|
      if e.datum == 2 && e.next.datum == 3
        DoubleLinkedList::Sequence.new(head: e, last: e.next)
      end
    end
    expect(select.count).to eq 1
    expect(select.first).to be_a DoubleLinkedList
    expect(select.first.to_a).to eq [2, 3]
  end

  it 'count' do
    expect(list.head.count).to eq 4
  end

  it 'next_count' do
    expect(list.head.next_count).to eq 3
    expect(list.next.next_count).to eq 2
  end

  it 'prev_count' do
    expect(list.head.prev_count).to eq 0
    expect(list.next.prev_count).to eq 1
    expect(list.last.prev_count).to eq 3
  end

  it 'included_prev_count' do
    expect(list.head.included_prev_count).to eq 1
    expect(list.next.included_prev_count).to eq 2
    expect(list.last.included_prev_count).to eq 4
  end
end
