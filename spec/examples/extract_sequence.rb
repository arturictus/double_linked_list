class GroupTrips
  attr_reader :llist

  def self.call(llist, traveller_home)
    new(llist).chunk(traveller_home)
  end

  def initialize(llist)
    @llist = llist
  end

  def output(traveller_home)
    @output ||= llist.select_by do |elem|
                  case elem.datum.type
                  when 'Flight'
                    Flight.new(elem, nil, nil).head_and_last(traveller_home)
                  when 'Hotel'
                  end
                end
  end
  alias_method :extract_sequences, :output

  class Flight
    attr_reader :elem,
                # :current_llist,
                # :acc,
                :datum,
                :home

    def initialize(elem, current_llist, acc)
      @elem = elem
      @current_llist = current_llist
      @acc = acc
      @datum = elem.datum

    end

    def head_and_last(home)
      palindromes
      # if datum.id == 3
      #   head = elem.find_previous_by do |e|
      #     e.datum.id == 1
      #   end
      #   { head: head.datum, last: elem.datum }
      # end
    end

    def palindromes
      found = nil
      elem.each do |e|
        if is_flight?(e) && go_and_return?(e)
          found = DoubleLinkedList::Sequence.new(head: elem, last: e)
        end
        break if found
      end
      found
    end

    private

    def go_and_return?(element)
      return unless is_flight?(element)
      element.datum.destination == datum.origin
    end

    def is_flight?(element)
      element.datum.type == 'Flight'
    end

    def current_head
      current_llist.head.datum
    end

    def prev
      elem.prev
    end
  end
end
