# Getting Started

## Introduction

 - One of the most popular testing library in Ruby
 - A family of libaries:
| Library             | Features                  |
| ------------------- | ------------------------- |
| rspec-core          | Runner and Syntax         |
| rspec-expectations  | Express desired outcomes  |
| rspec-mocks         | Test doubles              |


## Install & Setup

Install RSpec
```
gem install rspec --version 3.3
```

Make sure have correct version
```
rspec -v
3.3.2
```

Or, create Gemfile and paste:
```
source 'https://rubygems.org'

group :test do
    gem 'rspec', '~> 3.3.0'
end
```
Then, run 'bundle' in terminal.

Make sure rspec in bundle is correct.
```
bundle exec rspec -v
```

## Your First Spec

Create a folder, 'lightning-poker'
```
mkdir lightning-poker
cd lightning-poker
```

Create a card.rb file with content:
```
class Card
    def initialize(suit:, rank:)
        @suit = suit
        @rank = case rank
        when :jack then 11
        when :queen then 12
        when :king then 13
        else rank
        end
    end
    
    def suit
        @suit
    end
    
    def rank
        @rank
    end
end


RSpec.describe 'a playing card' do
  it 'has a suit' do
    raise unless Card.new(suit: :spades, rank: 4).suit == :spades
  end
  
  it 'has a rank' do
    raise unless Card.new(suit: :spades, rank: 4).rank == 4
  end
  
  describe 'a jack' do 
    it 'ranks higher than a 10' do
      lower = Card.new(suit: :spades, rank: 10)
      higher = Card.new(suit: :spades, rank: :jack)
      
      raise unless higher.rank > lower.rank
    end
  end
  
  describe 'a queen' do 
    it 'ranks higher than a jack' do
      lower = Card.new(suit: :spades, rank: :jack)
      higher = Card.new(suit: :spades, rank: :queen)
      
      raise unless higher.rank > lower.rank
    end
  end
  
  describe 'a king' do 
    it 'ranks higher than a queen' do
      lower = Card.new(suit: :spades, rank: :queen)
      higher = Card.new(suit: :spades, rank: :king)
      
      raise unless higher.rank > lower.rank
    end
  end
end
```

### Rspec Motivation
 - Automatically verfiy correctness
 - Document desired behaviour

### RSpec Methods
| Method      | Meaning                       |
| ----------- | ----------------------------- |
| it          | Specify a property. "Example" |
| describe    | Group examples/properties     |

### Execute RSpec
```
rspec card.rb
```
Or
```
rspec --format doc card.rb
```

You can also export it as a html:
```
rspec --format html --color card.rb > result.html
```

## Work Flow

1. Write Code
2. Test Code (Happy case)
3. Test Code (Purposely test Fail case by providing wrong input)
4. Test Code (Purposely test Fail case by breaking your code)

## Why do we write Unit Testing at all?
- CONFIDENCE
- Spec should not be a complete testing of every single thing.
- Test for confidence, not proof.

# Notes on Ruby
**:variable** are "Symbols"

A Symbol is the most basic Ruby object you can create. It's just a name and an internal ID. Symbols are useful because a given symbol name refers to the same object throughout a Ruby program. Symbols are more efficient than strings. Two strings with the same contents are two different objects, but for any given name there is only one Symbol object. This can save both time and memory.

**$variable** are "Global Variables"

**@variable** are "Instance Variables" (specific to an instance, but not to class)

**@@variable** are "Class Variables" (specific to class)

**VARIABLE** are "Constants".

A variable whose name **begins** with an uppercase letter (A-Z) is a constant. A constant can be reassigned a value after its initialization, but doing so will generate a warning. Every class is a constant.

Trying to access an uninitialized constant raises the NameError exception.