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

Or, run:
```
bundle gem myproject
cd myproject
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


## Writing Compact Specifications

### Concept Summary
1. Reduce Dependency

Card.new(suit: :spades, rank: 4) --> card(rank: 4)

2. Spec Behaviour, not implementation:

Testing with Set.

### 1. Spec should only change when behaviour does & Helper methods to bypass private 'new' methods.

Example:

```
it 'has a suit' do
  raise unless Card.new(suit: :spades, rank: 4).suit == :spades
end

it 'has a rank' do
  raise unless Card.new(suit: :spades, rank: 4) == 4
end
```
Above is bad, because the spec says 'has a suit', but we are testing more than just the suit of the card.
We will also change the structure incase the 'new' method of class is private (in which we normally wouldn't be able to call it from outside.)

Example of refactor:
```
def Card(params = {})
  defaults = {
    suit: :hearts,
    rank: 7
  }

  Card.new(**defaults.merge(params)).values_at(:suit, :rank)    # will be described later on.
end

it 'has a suit' do
  raise unless card(suit: :spades).suit == :spades
end

it 'has a rank' do
  raise unless card(rank: 4). rank == 4
end
```

### 2. Group tests with 'describe' and 'context'
Now consider the below code:

```
  it 'has a suit' do
    raise unless card(suit: :spades).suit == :spades
  end
  
  it 'has a rank' do
    raise unless card(rank: 4).rank == 4
  end

  it `is equal to self` do 
    subject = card(suit: :spades, rank: 4)
    other = card(suit: :spades, rank: 4)
    raise unless subject == other
  end

  it `is not equal to a card of a different suit` do 
    subject = card(suit: :spades, rank: 4)
    other   = card(suit: :hearts, rank: 4)
    raise unless subject != other
  end
  
  it `is not equal to a card of a different rank` do 
    subject = card(suit: :spades, rank: 4)
    other   = card(suit: :spades, rank: 5)
    raise unless subject != other
  end

  it 'is hash equal to itself' do 
    subject = card(suit: :spades, rank: 4)
    other   = card(suit: :spades, rank: 4)
    raise unless Set.new([subject, other]).size == 1
  end

  it 'is not hash equal to a card of differing suit' do 
    subject = card(suit: :spades, rank: 4)
    other   = card(suit: :hearts, rank: 4)
    raise unless Set.new([subject, other]).size == 2
  end

  it 'is not hash equal to a card of differing rank' do 
    subject = card(suit: :spades, rank: 4)
    other   = card(suit: :spades, rank: 5)
    raise unless Set.new([subject, other]).size == 2
  end
```

To summarize it for the first example:
```
  it `is equal to self` do ...

  it `is not equal to a card of a different suit` do ...
  
  it `is not equal to a card of a different rank` do ...

  it 'is hash equal to itself' do ...

  it 'is not hash equal to a card of differing suit' do ...

  it 'is not hash equal to a card of differing rank' do ...
```

The code above is bad because it is not grouped. Below, is an improvement version:

```
  context 'equality' do
    describe 'comparing to self' do
      it `is equal to self` do ...
      it 'is hash equal to itself' do ...
    end

    describe 'comparing to a card of different rank' do
      it `is not equal` do ...
      it 'is not hash equal' do ...
    end

    describe 'comparing to a card of different suit' do
      it `is not equal to a card of a different suit` do ...
      it 'is not hash equal to a card of differing suit' do ...
    end
  end
```

We can improve it even more by using, "context", which is just  another alias for describe.
Additionally, subject and other are being defined repeatedly. We can create a definition for it so reduce the # of repetitions.

```
 context 'equality' do
    def subject
      @subject ||= card(suit: :spades, rank: 4)
    end

    describe 'comparing to self' do
      def other 
        @other ||= card(suit: :spades, rank: 4)
      end

      it `is equal to self` do ...
      it 'is hash equal to itself' do ...
    end

    describe 'comparing to a card of different rank' do
      def other 
        @other ||= card(suit: :hearts, rank: 4)
      end
      it `is not equal` do ...
      it 'is not hash equal' do ...
    end

    describe 'comparing to a card of different suit' do
      def other 
        @other ||= card(suit: :hearts, rank: 5)
      end
      it `is not equal` do ...
      it 'is not hash equal' do ...
    end
  end
```
### 3. Shared Examples

Now, we also notice that 'comparing to a card of different suit' and '...different rank' has very methods in their 'is not equal' and 'is not hash equal'.
Here, we can use "shared examples" (https://relishapp.com/rspec/rspec-core/docs/example-groups/shared-examples):

```
  shared_examples_for 'an unequal card' do
    ...
  end

  it_behaves_like 'an unequal card'
```

Example of the whole code with shared_examples is:

```
  context 'equality' do
    def subject
      @subject ||= card(suit: :spades, rank: 4)
    end

    describe 'comparing against self' do
      def other
        @other ||= card(suit: :spades, rank: 4)
      end

      it `is equal to self` do 
        raise unless subject == other
      end

      it 'is hash equal' do 
        raise unless Set.new([subject, other]).size == 1
      end
    end

    shared_examples_for 'an unequal card' do
     it `is not equal` do 
        raise unless subject != other
      end

      it 'is not hash equal' do 
        raise unless Set.new([subject, other]).size == 2
      end
    end

    describe 'comparing to a card of different suit' do
      def other
        @other ||= card(suit: :hearts, rank: 4)
      end

      it_behaves_like 'an unequal card'
    end

    describe 'comparing to a card of different rank' do
      def other
        @other ||= card(suit: :spades, rank: 5)
      end
      
      it_behaves_like 'an unequal card'
    end
  end
```

### 4. Using let or subject to simplify def

A final improvement is to change:
```
def other
  @other ||= card(suit: :spades, rank: 5)
end
```

For every def other, we can change it to:
```
let(:other) { card(suit: :spades, rank: 4) }
```

Another shortcut (since it's so common) is to change 'let' into:
subject == let(:subject)
```
subject{ card(suit: :spades, rank: 4) }
```

## Deep Dive

Consider code

```
RSpec.describe 'an array' do
    def build_array(*args)
        [@args]
    end
    
    puts self
    puts self.class
    puts 
    
    it 'has a length' do
      puts self
      puts self.class
      puts self.object_id
      puts 
      raise unless build_array("a").length == 1
    end
    
    it 'has a first element' do
      puts self
      puts self.class
      puts self.object_id
      puts 
      raise unless build_array("a").length == 1
    end
end
```
This will output:

```
Finished in 0.025 seconds (files took 1.69 seconds to load)
1 example, 0 failures

C:\Users\Administrator\Desktop\rspec\Getting Started\DeepDive\deepDive\spec>rspec deepDive_spec.rb
RSpec::ExampleGroups::AnArray
Class

#<RSpec::ExampleGroups::AnArray:0x28eaa59a>
RSpec::ExampleGroups::AnArray
2000

.#<RSpec::ExampleGroups::AnArray:0x41fbdac4>
RSpec::ExampleGroups::AnArray
2002


Finished in 0.087 seconds (files took 2.66 seconds to load)
2 examples, 0 failures
```

Notice that the self in describe block is executing in context of a new class.
Each it block executes in that instance of array. 
Each it block is different from the other.

### Keywords

| Keyword             | Concept                   |
| ------------------- | ------------------------- |
| describe            | Example Group             |
| it                  | Example                   |

## Types of Tests

### Unit Test
Do our objects do the right thing, and are they covenient to work with?
Test specific components.

### Integration Test
Testing Active Record, and Rails

Does our code work against objects we can't change?

### Acceptance Test
Does the 'whole' system work?

## Hooks

### Before hooks
Before hooks are run before every test before every group and sub-group

Can also configure before hooks in your rspec configuration file (Rspec.configure)
```
require "rspec/expectations"

RSpec.configure do |config|
  config.before(:each) do
    @before_each = "before each"
  end
  config.before(:all) do
    @before_all = "before all"
  end
end

describe "stuff in before blocks" do
  describe "with :all" do
    it "should be available in the example" do
      @before_all.should == "before all"
    end
  end
  describe "with :each" do
    it "should be available in the example" do
      @before_each.should == "before each"
    end
  end
end
```

### Meta Data

Sometimes we might want to run the before hook in most cases, but not all. In that case, we can use a metadata. It's almost like passing a boolean in the 'describe' and that will control if the before hook executes or not.

### Hook Scopes

You can control if you want the before hook to apply to once per example, example group or spec run.


| Keyword   | Old Keyword      | Scope                              |
| --------- | ---------------- | ---------------------------------- |
| example   | each             | Once per example (it)              |
| context   | all              | Once per example group (describe)  |
| suite     | suite            | Once per spec run                  |

```
Eg:
before(:all) do
...
end
```

From https://relishapp.com/rspec/rspec-core/v/2-2/docs/hooks/before-and-after-hooks#define-before(:each)-block

```
require "rspec/expectations"

class Thing
  def widgets
    @widgets ||= []
  end
end

describe Thing do
  before(:each) do
    @thing = Thing.new
  end

  describe "initialized in before(:each)" do
    it "has 0 widgets" do
      @thing.should have(0).widgets
    end

    it "can get accept new widgets" do
      @thing.widgets << Object.new
    end

    it "does not share state across examples" do
      @thing.should have(0).widgets
    end
  end
end
```

```
require "rspec/expectations"

class Thing
  def widgets
    @widgets ||= []
  end
end

describe Thing do
  before(:all) do
    @thing = Thing.new
  end

  describe "initialized in before(:all)" do
    it "has 0 widgets" do
      @thing.should have(0).widgets
    end

    it "can get accept new widgets" do
      @thing.widgets << Object.new
    end

    it "shares state across examples" do
      @thing.should have(1).widgets
    end
  end
end
```

```
describe "an error in before(:all)" do
  before(:all) do
    raise "oops"
  end

  it "fails this example" do
  end

  it "fails this example, too" do
  end

  after(:all) do
    puts "after all ran"
  end

  describe "nested group" do
    it "fails this third example" do
    end

    it "fails this fourth example" do
    end

    describe "yet another level deep" do
      it "fails this last example" do
      end
    end
  end
end
```
### Types of Hook
https://relishapp.com/rspec/rspec-core/v/2-0/docs/hooks

### Why not Hooks?

In short, easy to lose track of it. Reason is:

 - Not localized to the spec
 - Can't look at the test and know exactly what is running.
 - Recommend not put in config as it is in another file - more complexity.
 
 Always ask: is there a more local way to do this?

## Recap

Behavior not Implementation
