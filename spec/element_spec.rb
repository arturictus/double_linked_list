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
end
