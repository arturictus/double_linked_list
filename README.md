# DoubleLinkedList

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

__find:___

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
  User.new(id: 1),
  User.new(id: 2),
  User.new(id: 3)
]
llist = DoubleLinkedList.from_a(users)
llist.find_by{ |elem| elem.id == 1 }.datum.id #=> 1
```

__find_previous:__

```ruby
llist = DoubleLinkedList.from_a(1, 2, 3)
llist.find_previous(3).datum #=> 2
llist.find_previous(2).datum #=> 1
llist.find_previous(1) #=> nil
```

__find_previous_by:__
```ruby
User = Struct.new(:id)
users = [
  User.new(id: 1),
  User.new(id: 2),
  User.new(id: 3)
]
llist = DoubleLinkedList.from_a(users)
llist.find_by{ |elem| elem.id == 2 }.datum.id #=> 1
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
1
2
3
```

__map:__
```ruby
DoubleLinkedList.from_a(1, 2, 3).map { |e| e.datum + 1}
=> [2, 3, 4]
```

__reverse_each:__
```ruby
DoubleLinkedList.from_a(1, 2, 3).reverse_each { |e| puts e.datum }
3
2
1
```




## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false ---` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/double_linked_list.
