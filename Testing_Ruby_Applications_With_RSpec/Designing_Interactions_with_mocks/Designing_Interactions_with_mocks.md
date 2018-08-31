# Designing Interactions with Mocks

LINK: https://github.com/rspec/rspec-mocks


## Designing with Mocks

Firstly, we want to intercept any external dependencies, such as puts and print calls.

```
example 'not betting on losing hand' do
	allow(HighCard::CLI).to receive(:puts)		# intercept puts method
	allow(HighCard::CLI).to receive(:print)		# intercept print mehtod
	allow(HighCard::CLI).to receive(:foo).with("whoami").and_return("tester")	#intercept foo("whoami"), return "tester"
end
```

What if we have some object instance we need to intercept?, eg:
```
bank = Bank.new(...)
account = bank.accounts.detect{...}
```

We can use "allow_any_instance_of" method to get the instance and return a fake class. 
Note that the fake class is nothing but a class that matches the interface of the class we are trying to mock.
Eg:
```
class FakeAccount
	def name; "tester"; end
	def credit!(*_); end
	def debit!(*_); end
	def balance(*_); end
end
...
allow_any_instance_of(HighCard::Bank).to receive(:accounts).and_return([
	FakeAccount.new
])
```
What if you need to return different output when the method is called multiple times:

```
allow(Card).to receive(:build).and_return(value1, value2, value3) # return value1 first time, then value2, then value3
```

Allow vs Expect. If you have the code, below: while 'puts' can be called multiple times (because we have allow), it has to be called with "you won!" exactly once because of the 'expect'.

```
allow(HighCard:CLI).to receive(:puts)
expect(HighCard::CLI).to receive(:puts).with("You won!")
```

## Test Doubles
Both mock and stub are aliases of the more generic double.

Test Doubles is a generic term for any object that stands in for a real object during a test ("stunt double").

Doubles are "strict" by default - meaning that any message you have not allowed or expected will trigger an error. 

Link: https://relishapp.com/rspec/rspec-mocks/v/3-8/docs/basics

For example:
```
RSpec.describe "A test double" do
  it "raises errors when messages not allowed or expected are received" do
    dbl = double("Some Collaborator")
    dbl.foo
  end
end
```

will give

```
#<Double "Some Collaborator"> received unexpected message :foo with (no args)
```

### Allow messages
```
RSpec.describe "allow" do
  it "returns nil from allowed messages" do
    dbl = double("Some Collaborator")
    allow(dbl).to receive(:foo)
    expect(dbl.foo).to be_nil
  end
end
```

### Expecting messages
```
RSpec.describe "An unfulfilled positive message expectation" do
  it "triggers a failure" do
    dbl = double("Some Collaborator")
    expect(dbl).to receive(:foo)
  end
end
```

## Listening to your mocks.

You can use argument matchers to specify a type or a specific argument that you expect, and then control the returning method. 

## Null Objects

If you just do:

```
instance_double("some_class")
```

You will need to add allows to make the methods work (eg. even your puts method)

But if you do:
```
instance_double("some_class").as_null_object
```
You don't need to add all the 'allows' that you would've.










