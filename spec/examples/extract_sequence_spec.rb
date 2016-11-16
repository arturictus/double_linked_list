require 'spec_helper'
require 'contextuable'
require File.expand_path('extract_sequence', __dir__)

describe 'Extract Sequence' do
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

  let(:missing_initial) do
    [
      # Contextuable.new(id: 12, origin: 'Barcelona', destination: 'Madrid', type: 'Flight'),
      Contextuable.new(id: 13, origin: 'Madrid', destination: 'Rio', type: 'Flight'),
      Contextuable.new(id: 14, city: 'Rio', type: 'Hotel'),
      Contextuable.new(id: 15, origin: 'Rio', destination: 'Madrid', type: 'Flight'),
      Contextuable.new(id: 16, origin: 'Madrid', destination: 'Barcelona', type: 'Flight')
    ]
  end
  let(:llist) do
    collection = go_and_return_to_madrid +
                   go_and_return_to_rio +
                   scales +
                   missing_initial
    DoubleLinkedList.from_a(collection)
  end

  let(:chunker) do
    GroupTrips.new(llist)
  end
  context 'when we have user home' do
    subject { chunker.extract_sequences('Barcelona') }
    it 'finds barcelona Madrid trip' do
      expect(subject.first.to_a).to eq go_and_return_to_madrid
    end
    it 'finds barcelona Rio trip' do
      expect(subject[1].to_a).to eq go_and_return_to_rio
    end
    it 'finds scales' do
      expect(subject[2].to_a).to eq scales
    end
    it 'finds missing_initial' do
      expect(subject[3].to_a).to eq missing_initial
    end
  end
end
