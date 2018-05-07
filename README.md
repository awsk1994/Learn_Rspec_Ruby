# Learn_Rspec_Ruby
Learning Module for Rspec
 - [(Archived) Tutorial: RSpec The Right Way](Archive/RSpec_The_Right_Way.md)
 - [Tutorial: Testing Ruby Applications with RSpec](Testing_Ruby_Applications_With_RSpec.md)


# Notes on Ruby
**:variable** are "Symbols"

 - A Symbol is the most basic Ruby object you can create. It's just a name and an internal ID. Symbols are useful because a given symbol name refers to the same object throughout a Ruby program. Symbols are more efficient than strings. Two strings with the same contents are two different objects, but for any given name there is only one Symbol object. This can save both time and memory.

**$variable** are "Global Variables"

**@variable** are "Instance Variables" (specific to an instance, but not to class)

**@@variable** are "Class Variables" (specific to class)

**VARIABLE** are "Constants".
 - A variable whose name **begins** with an uppercase letter (A-Z) is a constant. A constant can be reassigned a value after its initialization, but doing so will generate a warning. Every class is a constant.
 - Trying to access an uninitialized constant raises the NameError exception.