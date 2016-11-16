class DoubleLinkedList
  class Element < Struct.new(:datum, :previous, :_next)
    include Enumerable
    alias_method :next, :_next
    alias_method :prev, :previous

    def each(&block)
      block.call self
      _next.each(&block) if _next
    end

    def chunk_by(acc, &block)
      if acc.empty?
        acc << DoubleLinkedList.from_a(self.datum)
      else
        if block.call(self, acc.last, acc)
          acc << DoubleLinkedList.from_a(self.datum)
        else
          acc.last << self.datum
        end
      end
      _next ? _next.chunk_by(acc, &block) : acc
    end

    def select_by(acc, &block)
      if acc.empty?
        acc << DoubleLinkedList.from_a(self.datum)
      else
        if block.call(self, acc.last, acc)
          acc << DoubleLinkedList.from_a(self.datum)
        else
          acc.last << self.datum
        end
      end
      _next ? _next.select_by(acc, &block) : acc
    end

    def find_previous_by(&block)
      _finder(:reverse_each, &block)
    end

    def find_next_by(&block)
      _finder(:each, &block)
    end

    def reverse_each(&block)
      block.call self
      previous.reverse_each(&block) if previous
    end

    def append(datum)
      new_last = Element.new(datum, self, nil)
      self._next = new_last
      new_last
    end

    private

    def _finder(direction, &block)
      found = nil
      send(direction) do |elem|
        found = elem if block.call(elem)
        break if found
      end
      found
    end
  end
end
