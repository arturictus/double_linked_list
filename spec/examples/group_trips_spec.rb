require 'double_linked_list'
require 'contextuable'

describe 'Group by Trip' do
  let(:go_and_return_to_madrid) do
    [
      Contextuable.new(id: 1, origin: 'Barcelona', destination: 'Madrid', type: 'Flight'),
      Contextuable.new(id: 2, city: 'Madrid', type: 'Hotel'),
      Contextuable.new(id: 3, origin: 'Madrid', destination: 'Barcelona', type: 'Flight')
    ]
  end
  let(:go_and_return_to_rio) do
    [
      Contextuable.new(id: 4, origin: 'Barcelona', destination: 'Rio', type: 'Flight'),
      Contextuable.new(id: 5, city: 'Rio', type: 'Hotel'),
      Contextuable.new(id: 6, origin: 'Rio', destination: 'Barcelona', type: 'Flight')
    ]
  end
  let(:scales) do
    [
      Contextuable.new(id: 7, origin: 'Barcelona', destination: 'Madrid', type: 'Flight'),
      Contextuable.new(id: 8, origin: 'Madrid', destination: 'Rio', type: 'Flight'),
      Contextuable.new(id: 9, city: 'Rio', type: 'Hotel'),
      Contextuable.new(id: 10, origin: 'Rio', destination: 'Madrid', type: 'Flight'),
      Contextuable.new(id: 11, origin: 'Madrid', destination: 'Barcelona', type: 'Flight')
    ]
  end
  let(:llist) do
    collection = go_and_return_to_madrid + go_and_return_to_rio + scales
    DoubleLinkedList.from_a(collection)
  end
  subject do
    llist.chunk_by do |elem, current_llist, acc|
      datum = elem.datum
      # prev = elem.prev.try(:datum)
      # _next = elem.next.datum
      current_head = current_llist.head.datum
      case datum.type
      when 'Flight'
        datum.origin == 'Barcelona' #|| (elem.prev && elem.prev.datum.type == 'Flight' && elem.prev.datum.destination == 'Barcelona') || (current_head.origin == datum.destination)
      when 'Hotel'
      end
    end
  end
  it 'finds barcelona Madrid trip' do
    expect(subject.first.to_a).to eq go_and_return_to_madrid
  end
  it 'finds barcelona Rio trip' do
    expect(subject[1].to_a).to eq go_and_return_to_rio
  end
  it 'finds scales' do
    expect(subject[2].to_a).to eq scales
  end

end
