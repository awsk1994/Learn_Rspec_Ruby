# Getting Started

## Introduction

 - One of the most popular testing library in Ruby
 - A family of libaries:

| Library             | Features                  |
| ------------------- | ------------------------- |
| rspec-core          | Runner and Syntax         |
| rspec-expectations  | Express desired outcomes  |
| rspec-mocks         | Test doubles              |

### Rspec Motivation
 - Automatically verfiy correctness
 - Document desired behaviour

### Work Flow

1. Write Code
2. Test Code (Happy case)
3. Test Code (Purposely test Fail case by providing wrong input)
4. Test Code (Purposely test Fail case by breaking your code)

### Why do we write Unit Testing at all?
- CONFIDENCE
- Spec should not be a complete testing of every single thing.
- Test for confidence, not proof.

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


### RSpec Methods
| Method      | Meaning                       |
| ----------- | ----------------------------- |
| it          | Specify a property. "Example" |
| describe    | Group examples/properties     |

### Testing your Ruby Code
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

## Get Organized
 - Spec files and Ruby files should be in separate folders.
 1. Move card.rb into a lib folder, and the spec code into a card_spec.rb file inside a spec folder.
 2. Remember to add 'require('card.rb') inside the spec code as it doesn't know where the card.rb file is
     - require('card.rb') will work because rspec recognizes lib and spec folder.

 3. Now if you run 'rspec spec' in terminal one layer above spec folder, it will, by default, run all the spec files in it.

### Adding Spec Helper
In spec folder, add spec_helper.rb: 
```
 RSpec.configure do |config|
  config.warnings = true
end
```

This contains **global** configurations for our spec (will be explained more later).

To use this, we have to add '--require ./spec/spec_helper.rb' in our cli.
```
rspec --require ./spec/spec_helper.rb spec
```

### Flags
It is annoying to have to add "--format doc --color --require ./spec/spec_helper.rb spec" every single time.

To solve this, we use flags.

1. create a file called ".rspec" with content (one option per line) in parent folder of spec folder:
```
--color
--require ./spec/spec_helper.rb
--format doc
```

2. Now, we can run 'rspec spec' in without the option in cli.

The files should be in the following tree format:
```
C:.
│   .rspec
│   Gemfile
│   Gemfile.lock
│
├───lib
│       card.rb
│
└───spec
        card_spec.rb
        spec_helper.rb
```

### Read command line configuration options from files
You can do local, global and project scope for configuration options. To read more about it, go to https://relishapp.com/rspec/rspec-core/v/3-7/docs/configuration/read-command-line-configuration-options-from-files

Local > project > global


## Compact Specifications
