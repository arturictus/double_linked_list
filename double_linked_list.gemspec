# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'double_linked_list/version'

Gem::Specification.new do |spec|
  spec.name          = "double_linked_list"
  spec.version       = DoubleLinkedList::VERSION
  spec.authors       = ["Artur Pañach"]
  spec.email         = ["arturictus@gmail.com"]

  spec.summary       = %q{The missing Ruby Double Linked List}
  spec.description   = %q{The missing Ruby Double Linked List.}
  spec.homepage      = "https://github.com/arturictus/double_linked_list"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
  # spec.add_development_dependency "false ---", "~> "
end
