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
    :count,
    :all?,
    :any?
  ] => :head

  delegate [
    :reverse_each,
  ] => :last

  delegate [
    :[]
  ] => :to_a

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
  alias_method :<<, :append

  def find(datum)
    find_by do |elem|
      elem.datum == datum
    end
  end

  def find_by(&block)
    head.find_next_by(false, &block)
  end

  def reverse_find(datum)
    reverse_find_by do |elem|
      elem.datum == datum
    end
  end

  def reverse_find_by(&block)
    last.find_previous_by(false, &block)
  end

  def chunk_by(custom_dll = DoubleLinkedList, &block)
    head.chunk_by([], custom_dll, &block)
  end

  def select_by(&block)
    head.select_by(&block)
  end

  def to_a
    [].tap do |ary|
      each{ |elem| ary << elem.datum }
    end
  end

end

require 'double_linked_list/element'
require 'double_linked_list/sequence'
