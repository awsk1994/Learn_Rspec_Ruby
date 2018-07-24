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

###.each_cons(..)

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

~~ need to rewatch 'custom matchers'....