class DoubleLinkedList
  class Sequence
    attr_reader :head, :last
    def initialize(head:, last:)
      @head = head
      @last = last
    end

    def next
      return unless next?
      last.next
    end

    def next?
      last.next ? true : false
    end
  end
end
