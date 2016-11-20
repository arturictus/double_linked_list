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
      heads_and_tails = []
      second_iterate do |e|
        head_tail = block.call(e)
        if head_tail
          heads_and_tails << head_tail
        end
        head_tail
      end
      coll = []
      heads_and_tails.each do |seq|
        head = seq[:head]
        head_datum = head.datum
        list = DoubleLinkedList.from_a(head_datum)
        last = nil
        head.each do |elem|
          next if head_datum == elem.datum
          list << elem.datum
          last = elem.datum if elem.datum == seq[:last].datum
          break if last
        end
        coll << list
      end
      coll
    end

    def second_iterate(&block)
      found = iterate(&block)
      found[:last].next.second_iterate(&block) if found && found[:last] && found[:last].next
    end

    def iterate(&block)
      found = block.call(self)
      return found if found
      _next.iterate(&block) if _next
    end

    def find(datum)
      find_next_by do |elem|
        elem.datum == datum
      end
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

    protected

    def _finder(direction, &block)
      # found = block.call(self)
      # return found if found
      # send(direction)._finder(direction, &block) if send(direction)
      found = nil
      send(direction) do |elem|
        found = elem if block.call(elem)
        break if found
      end
      found
    end
  end
end
