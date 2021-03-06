class DoubleLinkedList
  class Element
    include Enumerable

    attr_reader :datum
    attr_accessor :previous, :_next

    def initialize(datum, previous = nil, _next = nil)
      @datum = datum
      @previous = previous
      @_next = _next
    end

    alias_method :next, :_next
    alias_method :prev, :previous

    def each(&block)
      block.call self
      _next.each(&block) if _next
    end

    # Avoid calling myself on finds
    def _each(&block)
      _next.each(&block) if _next
    end

    def count
      reduce(0) { |p| p + 1 }
    end
    alias_method :included_next_count, :count

    def next_count
      c = 0
      _each { c += 1 }
      c
    end

    def prev_count
      c = 0
      _reverse_each { c += 1 }
      c
    end

    def included_prev_count
      prev_count + 1
    end

    def find(datum)
      find_next_by do |elem|
        elem.datum == datum
      end
    end

    def find_previous_by(exclude_self = true, &block)
      method = exclude_self ? :_reverse_each : :reverse_each
      _finder(method, &block)
    end

    def find_next_by(exclude_self = true, &block)
      method = exclude_self ? :_each : :each
      _finder(method, &block)
    end

    # This is done to avoid calling self in the block
    # For not finding myself as the first element in the list
    def _reverse_each(&block)
      previous.reverse_each(&block) if previous
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

    def chunk_by(acc, custom_dll = DoubleLinkedList, &block)
      if acc.empty?
        acc << custom_dll.from_a(self.datum)
      else
        if block.call(self, acc.last, acc)
          acc << custom_dll.from_a(self.datum)
        else
          acc.last << self.datum
        end
      end
      _next ? _next.chunk_by(acc, custom_dll, &block) : acc
    end

    def select_by(&block)
      sequences = []
      find_multiple do |e|
        head_tail = block.call(e)
        if head_tail
          sequences << head_tail
        end
        head_tail
      end
      extract_sequences(sequences)
    end

    def method_missing(method, *args, &block)
      datum.send(method, *args, &block)
    end

    def respond_to_missing?(method_name, include_private = false)
      datum.respond_to?(method_name) ? true : false
    end

    protected

    def find_multiple(&block)
      found = each_until_found(&block)
      found.next.find_multiple(&block) if found && found.next?
    end

    def each_until_found(&block)
      found = block.call(self)
      return found if found
      _next.each_until_found(&block) if _next
    end

    def extract_sequences(sequences)
      sequences.each_with_object([]) do |seq, coll|
        head = seq.head
        head_datum = head.datum
        list = DoubleLinkedList.from_a(head_datum)
        last = nil
        head.find_multiple do |elem|
          next if head_datum == elem.datum
          list << elem.datum
          last = elem.datum if elem.datum == seq.last.datum
          break if last
        end
        coll << list
      end
    end

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
