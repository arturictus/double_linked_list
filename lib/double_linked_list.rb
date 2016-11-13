require "double_linked_list/version"
require 'forwardable'
class DoubleLinkedList
  extend Forwardable
  attr_accessor :head, :last
  delegate [
    :datum,
    :next,
    :map,
    :each,
    # :select
  ] => :head

  delegate [ :reverse_each ] => :last

  def initialize(datum)
    @head = (datum.is_a?(Element) ? datum : Element.new(datum))
  end

  class << self
    def from_a(*ary)
      elems = ary.flatten
      head = Element.new(elems.first)
      last = elems.drop(1).reduce(head) do |cur_last, datum|
        cur_last.append(datum)
      end
      new(head).tap do |o|
        o.last = last
      end
    end
  end

  def append(datum)
    self.last = last.append(datum)
  end


  def find(datum)
    find_by do |elem|
      elem == datum
    end
  end

  def find_by(&block)
    found = nil
    head.each do |elem|
      found = elem if block.call(elem.datum)
      break if found
    end
    found
  end

  def find_previous_by(&block)
    found = nil
    last.reverse_each do |elem|
      found = elem.previous if block.call(elem.datum)
      break if found
    end
    found
  end

  def find_previous(datum)
    find_previous_by do |elem|
      elem == datum
    end
  end

  class Element < Struct.new(:datum, :previous, :_next)
    include Enumerable
    alias_method :next, :_next
    alias_method :prev, :previous

    def each(&block)
      block.call self
      _next.each(&block) if _next
    end

    def each_from_last(&block)
      block.call self
      previous.each_from_last(&block) if previous
    end
    alias_method :reverse_each, :each_from_last

    def append(datum)
      new_last = Element.new(datum, self, nil)
      self._next = new_last
      new_last
    end
  end
end
