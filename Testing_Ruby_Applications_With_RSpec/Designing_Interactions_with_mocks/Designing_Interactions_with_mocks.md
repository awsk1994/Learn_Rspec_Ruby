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

