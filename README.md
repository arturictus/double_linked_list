# DoubleLinkedList

[![Build Status](https://travis-ci.org/arturictus/double_linked_list.svg?branch=master)](https://travis-ci.org/arturictus/double_linked_list)
[![Gem Version](https://badge.fury.io/rb/double_linked_list.svg)](https://badge.fury.io/rb/double_linked_list)
[![Code Climate](https://codeclimate.com/github/arturictus/double_linked_list/badges/gpa.svg)](https://codeclimate.com/github/arturictus/double_linked_list)
[![Test Coverage](https://codeclimate.com/github/arturictus/double_linked_list/badges/coverage.svg)](https://codeclimate.com/github/arturictus/double_linked_list/coverage)
[![Issue Count](https://codeclimate.com/github/arturictus/double_linked_list/badges/issue_count.svg)](https://codeclimate.com/github/arturictus/double_linked_list)

The missing Ruby Linked list

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'double_linked_list'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install double_linked_list

## Usage

__navigation:__
- `next`
- `previous` or `prev`

```ruby
llist = DoubleLinkedList.from_a(1, 2, 3)
llist.datum #=> 1
llist.next.datum #=> 2
llist.next.next.datum #=> 3
llist.next.next.next #=> nil
llist.next.next.prev.datum #=> 2
```
__last:__

```ruby
llist = DoubleLinkedList.from_a(1, 2, 3)
llist.last.datum #=> 3
```

__find:__

```ruby
llist = DoubleLinkedList.from_a(1, 2, 3)
two = llist.find(2)
two.datum #=> 2
two.next.datum #=> 3
llist.find(3).datum #=> 3
llist.find(9) #=> nil
```

__find_by:__
```ruby
User = Struct.new(:id)
users = [
  User.new(1),
  User.new(2),
  User.new(3)
]
llist = DoubleLinkedList.from_a(users)
llist.find_by{ |elem| elem.datum.id == 1 }.datum.id #=> 1
```

__append:__

```ruby
llist = DoubleLinkedList.from_a(1, 2, 3)
llist.append(4)
llist.last.datum #=> 4
llist.last.next #=> be_nil
llist.last.previous.datum #=> 3
```

## Enumerable

- `map`
- `each`
- `reverse_each`

__each:__
```ruby
DoubleLinkedList.from_a(1, 2, 3).each { |e| puts e.datum }
# 1
# 2
# 3
```

__map:__
```ruby
DoubleLinkedList.from_a(1, 2, 3).map { |e| e.datum + 1}
#=> [2, 3, 4]
```

__reverse_each:__
```ruby
DoubleLinkedList.from_a(1, 2, 3).reverse_each { |e| puts e.datum }
# 3
# 2
# 1
```

__chunk_by:__

It will split the Double linked list in multiple linked list if the block
returns `truly`.
The first element of the splitted array are the elememts that return true in the block.

```ruby
llist = DoubleLinkedList.from_a(1, 2, 3, 4)
chunked = llist.chunk_by do |e, current_llist|
  e.datum == 3 && current_llist.head.datum == 1
end
chunked.first.is_a? DoubleLinkedList #=> true
chunked.first.head.datum #=> 1
chunked.first.last.datum #=> 2
chunked.map{|ll| ll.to_a } #=> [[1, 2], [3, 4]]
```

__select_by:__

For selecting fractions of the linked list avoiding the elements not returned in between the selected head and last sequences.
In the block must be returned a `DoubleLinkedList::Sequence` instance and head and last in the `DoubleLinkedList::Sequence` must be a `DoubleLinkedList::Element` (the element is passed to the block)

```ruby
llist = DoubleLinkedList.from_a(1, 2, 3, 4)
select = llist.select_by do |e|
  if e.datum == 2 && e.next.datum == 3
    DoubleLinkedList::Sequence.new(head: e, last: e.next)
  end
end
select.is_a? Array #=> true
select.first.is_a? DoubleLinkedList #=> true
select.map{|ll| ll.to_a } #=> [[2, 3]]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false ---` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arturictus/double_linked_list.
