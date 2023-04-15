# ProbabilityTheory

Гем "ProbabilityTheory" - это библиотека на Ruby, которая содержит функции и модули для работы с комбинаторикой, различными игровыми механиками и математическими формулами.

## Installation

To install the "ProbabilityTheory" gem from the Git repository, follow these steps:

1) Install Git on your computer if it doesn't already exist.

2) Open the terminal and go to the directory of your project.

3) Type the command gem install bundler to install Bundler if it is not already installed on your computer.

4) Create a Gemfile in the root directory of the project.

5) Open Gemfile in a text editor and add the following line:
``` gem 'Probability Theory', git: 'https://github.com/T0ren4ik/probabilityTheory' ```

6) Save the changes to the Gemfile.

7) Enter the bundle install command to install the "Probability Theory" gem and its dependencies from the Git repository.

Ready! Now you can use the "ProbabilityTheory" gem in your project.

## Usage

The gem has the following classes, modules and functions:

### DeckOfCards

The DeckOfCards class represents a deck of playing cards that can be shuffled, cards can be taken from, cards can be returned to the deck.

#### Creating a deck of cards

To create a new deck of cards, create an instance of the DeckOfCards class, passing in the number of cards you want in the deck. The count parameter should be either 36 or 52:

``` deck = DeckOfCards.new(36) # Creates a deck with 36 cards ```ruby
Shuffling the deck
To shuffle the deck of cards, call the shuffle_cards method:

#### Shuffling the deck

To shuffle the deck of cards, call the shuffle_cards method:
    deck.shuffle_cards

#### Taking a card

To take a card from the deck, call the take_card method:

```Ruby
card = deck.take_card
puts card # prints a string representation of the card taken
```

If the deck is empty, take_card will raise a RuntimeError:

```Ruby
begin
  card = deck.take_card
rescue RuntimeError => e
  puts e.message # prints "The deck is empty"
end
```

#### Pulling multiple cards

To pull multiple cards from the deck, call the pull_cards method with a number of cards to pull:

```Ruby
cards = deck.pull_cards(5) # Pulls 5 cards from the deck
puts cards # prints an array of strings, each string represents a card pulled
```

If the deck doesn't have enough cards to pull, pull_cards will raise an ArgumentError:

```Ruby
begin
  cards = deck.pull_cards(37)
rescue ArgumentError => e
  puts e.message # prints "Not enough cards in the deck"
end
```

#### Returning a card to the deck

To return a card to the deck, call the back_to_deck method with the card you want to return:

```Ruby
deck.back_to_deck("7 of hearts") # Returns the card "7 of hearts" to the deck
```

If the card is already in the deck, back_to_deck will raise an ArgumentError:

```Ruby
begin
  deck.back_to_deck("7 of hearts")
rescue ArgumentError => e
  puts e.message # prints "The card is already in the deck"
end
```

#### Possible errors in the DeckOfCards class are

* ArgumentError is raised if the count of cards passed to initialize is neither 36 nor 52, or if pull_cards or back_to_deck are called with an invalid argument. This error is raised when the input value is not valid, such as a negative number, a string or a float, or when an argument is missing.
* RuntimeError is raised if take_card is called on an empty deck. This error is raised when there are no cards left in the deck, and the user tries to draw another card.

Here are some examples of how to use the DeckOfCards class:

```Ruby
# Create a deck of 36 cards
deck = DeckOfCards.new(36)

# Shuffle the deck
deck.shuffle_cards

# Draw one card from the deck
card = deck.take_card
puts "You drew a #{card} from the deck."

# Draw three cards from the deck
cards = deck.pull_cards(3)
puts "You drew three cards from the deck: #{cards.join(', ')}."

# Add a card back to the deck
deck.back_to_deck(card)
puts "You put the #{card} back to the deck."

# Create a deck of 52 cards
deck = DeckOfCards.new(52)

# Shuffle the deck
deck.shuffle_cards

# Draw five cards from the deck
cards = deck.pull_cards(5)
puts "You drew five cards from the deck: #{cards.join(', ')}."

# Try to draw another card, but the deck is empty
begin
  card = deck.take_card
rescue RuntimeError => e
  puts e.message
end

# Try to add an already existing card back to the deck
begin
  deck.back_to_deck(cards.first)
rescue ArgumentError => e
  puts e.message
end

# Try to pull more cards than the deck has
begin
  deck.pull_cards(50)
rescue ArgumentError => e
  puts e.message
end
```

### Usage Guide for Dice Class

The Dice class represents a standard dice with a specified number of sides. It can be used to roll a dice, get the last roll result, roll the dice multiple times, calculate the average roll value, and count the number of occurrences of a specific value in a number of rolls.

#### Initialization

To create an instance of the Dice class, pass the number of sides as a parameter to the constructor. The sides argument must be a positive integer, otherwise an ArgumentError will be raised.

```ruby
# Create a dice with 6 sides
dice = Dice.new(6)
```

#### Rolling the Dice

To roll the dice and get a random value between 1 and the number of sides, use the roll method.

```ruby
# Roll the dice once
dice.roll #=> 3
```

#### Last Roll Result

To display the result of the last roll, use the show_last_roll method. It will return a string with the result of the last roll or a message that no roll has been made yet.

```ruby
# Show the result of the last roll
dice.show_last_roll #=> "Last roll: 3"
```

#### Rolling Multiple Times

To roll the dice multiple times, use the roll_multiple method, which takes a positive integer argument representing the number of times the dice will be rolled. It will return an array with the results of each roll.

```ruby
# Roll the dice 3 times
dice.roll_multiple(3) #=> [5, 1, 6]
```

#### Average Roll Value

To calculate the average value of the rolls, use the average_roll method, which takes a positive integer argument representing the number of times the dice will be rolled. It will return an integer value representing the average roll value.

```ruby
# Calculate the average roll value after rolling the dice 10 times
dice.average_roll(10) #=> 3
```

#### Counting Occurrences

To count the number of times a specific value is rolled, use the count_occurrences method, which takes two positive integer arguments: the value to be counted and the number of times the dice will be rolled. It will return an integer value representing the number of times the specified value was rolled.

```ruby
# Count the number of times 4 is rolled after rolling the dice 10 times
dice.count_occurrences(4, 10) #=> 2
```

#### Possible Errors

ArgumentError is raised if the sides or the number of times argument passed to the initialize, roll_multiple, average_roll, or count_occurrences methods is not a positive integer.

### Module Features

This class provides several statistical functions that can be used to calculate different properties of data. Here's a brief overview of each method:

1) `expected_value(data)`: This method calculates the expected value of a dataset, which is the weighted average of all the values in the dataset. The input data must be an array of pairs of numbers, where the first number is the value and the second number is the probability of that value occurring. The output is a single number that represents the expected value of the dataset. This method raises an ArgumentError if the input data is not in the correct format.

Example usage:

```Ruby
data = [[1, 0.2], [2, 0.3], [3, 0.5]]
expected = expected_value(data) #=> 2.6
```

2) `variance(data)`: This method calculates the variance of a dataset, which is a measure of how spread out the values in the dataset are. The input data must be in the same format as the expected_value method. The output is a single number that represents the variance of the dataset. This method returns nil if the expected value is nil.
Example usage:

```Ruby
data = [[1, 0.2], [2, 0.3], [3, 0.5]]
variance = variance(data) #=> 0.46
```

3) `create_cdf(data)`: This method creates a cumulative distribution function (CDF) for a dataset. A CDF is a function that maps each value in the dataset to the cumulative probability of that value occurring. The input data must be an array of pairs of numbers, where the first number is the value and the second number is the probability of that value occurring. The output is an array of pairs of numbers, where the first number is a value in the dataset and the second number is the cumulative probability of that value occurring. This method raises an ArgumentError if the input data is not in the correct format.
Example usage:

```Ruby
data = [[1, 0.2], [2, 0.3], [3, 0.5]]
cdf = create_cdf(data) #=> [[1, 0.2], [2, 0.5], [3, 1.0]]
```

4) `covariance(x, y)`: This method calculates the covariance between two datasets, which is a measure of how the two datasets vary together. The input x and y should be arrays of numbers with the same size. The output is a single number that represents the covariance between x and y. This method raises an ArgumentError if x and y are not in the correct format.
Example usage:

```Ruby
x = [1, 2, 3, 4, 5]
y = [2, 4, 6, 8, 10]
cov = covariance(x, y) #=> 5.0
```

5) `covariance_matrix(data)`: The first function, covariance_matrix, calculates the covariance matrix of a dataset. It takes a single argument data, which should be a non-empty array of arrays, where each sub-array contains numeric values. The function returns a two-dimensional array representing the covariance matrix. The diagonal elements of this matrix represent the variances of the corresponding variables, while the off-diagonal elements represent the covariances between pairs of variables.

Here is an example of how to use covariance_matrix:

```Ruby
data = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
matrix = covariance_matrix(data)
puts matrix.inspect # [[1.0, 1.0, 1.0], [1.0, 1.0, 1.0], [1.0, 1.0, 1.0]]
```

6) `total_probability(events, probabilities)` calculates the total probability of a set of events, given their individual probabilities. It takes two arguments: events and probabilities, both of which are arrays of numeric values. It returns a single numeric value, which is the sum of all the probabilities.

7) `bayes_theorem(event, events, probabilities)` calculates the probability of a specific event, given a set of events and their probabilities. It takes three arguments: event, events, and probabilities, all of which are arrays of numeric values. It returns a single numeric value, which is the probability of the specified event.

Example usage:

```Ruby
events = [0.3, 0.2, 0.5]
probabilities = [0.4, 0.6, 0.2]

total_prob = total_probability(events, probabilities)
# Output: 1.0

event_prob = bayes_theorem(1, events, probabilities)
# Output: 0.2
```

Possible errors that can be raised:

* ArgumentError: Invalid input: expected two arrays of numeric values with the same size if the input arrays have different sizes or contain non-numeric values.
* ArgumentError: Invalid index: event index out of bounds if the specified event index is out of range.
* ArgumentError: Events probabilities don't add up to 1 if the sum of the probabilities is not equal to 1.

8) `bernoulli(p, k, n)`:  calculates the probability of k successes in n independent Bernoulli trials with probability p of success. The output is the probability of getting exactly k successes. The function expects three input values: p is a number between 0 and 1, k is an integer greater than or equal to 0, and n is an integer greater than or equal to 0. Raises an ArgumentError if any input is invalid.

```Ruby
p bernoulli(0.4, 3, 8)
# Output: 0.27869184
```

9)  `local_laplace(k, n, p)`: approximates the probability of getting k or more successes in n independent Bernoulli trials with probability p of success, using the local Laplace theorem. The output is an approximation of the probability. The function expects three input values: k is an integer greater than or equal to 0, n is a positive integer, and p is a number between 0 and 1. Raises an ArgumentError if any input is invalid.

```Ruby
p local_laplace(1400, 2400, 0.6)
# Output: 0.0041
```

10) `integral_laplace(a, b, n, p)`: approximates the probability of getting between a and b successes in n independent Bernoulli trials with probability p of success, using the integral Laplace theorem. The output is an approximation of the probability. The function expects four input values: a and b are integers, with a less than or equal to b, n is a positive integer, and p is a number between 0 and 1. Raises an exception if any input is invalid.

```Ruby
p integral_laplace(3.0, 7.0, 10, 0.5)
# Output:  0.796 
```

11) These are probability functions that calculate different probabilities based on inputs. Here's a brief summary of each function:

* `conditional_probability`: calculates the conditional probability of an event A given an event B.
* `product_joint`: calculates the joint probability of events A and B occurring together.
* `product_incompatible`: calculates the probability of events A and B occurring together assuming they are incompatible (i.e., they cannot occur together).
* `sum_incompatible`: calculates the probability of events A or B occurring assuming they are incompatible.
* `sum_joint`: calculates the probability of events A or B occurring, taking into account the possibility that they may occur together.

Each function takes the following inputs:

* `outcomes`: the total number of possible outcomes.
* `a_outcomes`: the number of outcomes where event A occurs.
* `b_outcomes`: the number of outcomes where event B occurs.

Each function returns a probability value as a float. Possible errors that can be raised include invalid input types, division by zero, or any other input that violates the mathematical constraints of the functions.

```Ruby
p product_joint(10, 3, 2), 0.01
# Output:  0.09

p product_incompatible(10, 3, 2), 0.01
# Output:  0.06

p sum_incompatible(10, 3, 2), 0.01
# Output:  0.5

p sum_joint(10, 3, 2)
# Output:  0.44
```

### Module Сombinatorics

The module combinatorics implements the following functionality:
* functions realizing combinatoric formulas
* enumerators generating combinanatoric entities given source iterable or natural number
* higher order enumerators helping to efficiently manipulate mentioned enumerators using lazy calculations principles

Let's go through all the parts one by one

#### Count combinatoric entities

Here a set of functions counting combinatoric entities is presented
* `permutations_count (n, [k1, k2, ...])`: counts permutations using a formula $P(n) = n!$. Also counts permutations with replace by a formula $P(n, k1..kn) = n! / (k1! * ... * kn!)$.
* `placements_count (n, k)`: counts placements using a formula $A(n, k) = n! / (n - k)!$.
* `replace_placements_count (n, k)`: counts replace_placements using a formula $A(n, k) = n^{k}$.
* `combinations_count (n, k)`: counts combinations using a formula $C(n, k) = n! / (n - k)! / k!$.
* `replace_combinations_count (n, k)`: counts replace_combinations using a formula $C(n, k) = n ^ k$.

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/T0ren4ik/probabilityTheory>.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
