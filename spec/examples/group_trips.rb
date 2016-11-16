class GroupTrips
  attr_reader :llist

  def self.call(llist, traveller_home)
    new(llist).chunk(traveller_home)
  end

  def initialize(llist)
    @llist = llist
  end

  def output(traveller_home)
    @output ||= llist.chunk_by do |elem, current_llist, acc|
                  case elem.datum.type
                  when 'Flight'
                    Flight.new(elem, current_llist, acc).chunk?(traveller_home)
                  when 'Hotel'
                  end
                end
  end
  alias_method :chunk, :output

  class Flight
    attr_reader :elem,
                :current_llist,
                :acc,
                :datum,
                :home

    def initialize(elem, current_llist, acc)
      @elem = elem
      @current_llist = current_llist
      @acc = acc
      @datum = elem.datum

    end

    def chunk?(home)
      @home = home
      [
        :is_origin_home?,
        :is_prev_dest_home?,
        # :current_llist_is_closed?
      ].any?{ |method| self.send(method) }
    end

    def is_origin_home?
      datum.origin == home
    end

    def is_prev_dest_home?
      prev &&
        prev.datum.type == 'Flight' &&
        prev.datum.destination == home
    end

    def current_llist_is_closed?
      prev &&
        current_head.type == 'Flight' &&
        prev.datum.type == 'Flight' &&
        current_head.origin == prev.datum.destination
    end

    private

    def current_head
      current_llist.head.datum
    end

    def prev
      elem.prev
    end
  end
end
