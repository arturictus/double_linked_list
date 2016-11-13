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
  subject { DoubleLinkedList.from_a(go_and_return_to_madrid, go_and_return_to_rio) }
  it 'finding barcelona Madrid trip' do
    out = subject.chunk_by do |elem, current_llist|
      datum = elem.datum
      case datum.type
      when 'Flight'
        current_llist.find_previous_by do |prev_elem|
          if prev_elem.datum.type == 'Flight'
            elem.datum.destination == prev_elem.datum.origin
          end
        end
      when 'Hotel'
      end
    end
    expect(out.first.to_a).to eq go_and_return_to_madrid
    expect(out[1].to_a).to eq go_and_return_to_rio
  end

end
