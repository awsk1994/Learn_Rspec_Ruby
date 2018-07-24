#Helpful Failures with Expectation

## Using expect.

Instead of using 
```
raise unless...
```

We can use 
```
expect(..).to_not eq(other)
```

Other eq comparison:
expect(..).to be < other

## Collection Matchers (working with arrays)

Instead of using a for loop to look through all the cards (like below):
```
Deck.all.each do |card|
	expect(card.rank).to be >= 7
end
```

We use do a .all.map to map it out and compare all.
```
expect(Deck.all.map {|card| card.rank}).to all(be >= 7)
```

An improvement can be:
```
expect(Deck.all).to all(have_attributes(rank: be >= 7))

```

Our 2nd and 3rd attempts also gives a much better error output.

## Custom Matcher

###\.each_cons(..)

```
irb(main):003:0> (1..5).each_cons(2).to_a
=> [[1, 2], [2, 3], [3, 4], [4, 5]]
```

### Usage
Using this, we can check if all cards are one after another using code blow:
```
it 'has contiguous ranks by suit' do
	Deck.all.group_by{|card| card.suit }.each do |suit, cards|
		contiguous = cards
			.map {|card| card.rank}
			.sort
			.each_cons(2)
			.all? {|x,y| x + 1 == y}
		expect(contiguous).to eq(true)
	end
end
```

We can wrap this up in custom matcher to have better error output, and syntax (now can do ".to be_contiguous").

```
RSpec::Matchers.define(:be_contiguous) do
	match do |array|
		!first_non_contiguous_pair(array)
	end

	failure_message do |array|										# Failure Message defined here.
		"%s and %s were not contiguous" % first_non_contiguous_pair(array)
	end

	def first_non_contiguous_pair(array)
		array
			.sort
			.each_cons(2)
			.detect {|x,y| x + 1 == y}								# use "detect"
	end
end

...

it 'has contiguous ranks by suit' do
	Deck.all.group_by {|card| card.suit }.each do |suit, cards|
		expect(cards.map {|card| card.rank}).to be_contiguous		# can use ".to be_contiguous"
	end
end
```

## How expectations work?

###Aggregate Failures

In code, below, the problem is we only get message for the 'first failure'.
```
it 'parses face cards' do
	expect(Card.from_string("JC")).to eq(Card.build(:clubs, :jack))
	expect(Card.from_string("QC")).to eq(Card.build(:clubs, :queen))
	expect(Card.from_string("KC")).to eq(Card.build(:clubs, :king))
end
```

Using 'aggregate_failures', the check for failure will continue after first fail.
```
it 'parses face cards' do
	aggregate_failures do
		expect(Card.from_string("JC")).to eq(Card.build(:clubs, :jack))
		expect(Card.from_string("QC")).to eq(Card.build(:clubs, :queen))
		expect(Card.from_string("KC")).to eq(Card.build(:clubs, :king))
	end
end
```

You can do it on the describe level too:

```
describe '.from_string', :aggregate_failures do
...
end
```

###Custom Example Builder (it_parses)
For example, we have:
```
describe '.from_string' do
	it 'parses 10' do
		expect(Card.from_string("10S")).to eq(Card.build(:spades, 10))
	end

	it 'parses face cards' do
		expect(Card.from_string("JC")).to eq(Card.build(:clubs, :jack))
		expect(Card.from_string("QC")).to eq(Card.build(:clubs, :queen))
		expect(Card.from_string("KC")).to eq(Card.build(:clubs, :king))
	end

end
```

We can create a method with it statement inside, and use it as a method.
```
describe '.from_string' do
	def self.it_parses(string, as: as)
		it "parses #{string}" do
			expect(Card.from_string(string)).to eq(as)
		end
	end

	it_parses "10S", as: Card.build(:spades, 10)
	it_parses "JC", as: Card.build(:clubs, :jack)
	it_parses "QC", as: Card.build(:clubs, :queen)
	it_parses "KC", as: Card.build(:clubs, :king)
end
```

###Boolean Composition
use .and and .or to chain expectations