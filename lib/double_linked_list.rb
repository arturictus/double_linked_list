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
    :reduce,
    # :find_next_by
  ] => :head

  delegate [
    :reverse_each,
    # :find_previous_by
  ] => :last

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

  def <<(datum)
    append(datum)
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

  def chunk_by(&block)
    head.chunk_by([], &block)
  end

  def to_a
    [].tap do |ary|
      each{ |elem| ary << elem.datum }
    end
  end

end

require 'double_linked_list/element'
