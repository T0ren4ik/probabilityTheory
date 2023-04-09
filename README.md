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

The Dice class simulates a dice with a specified number of sides. It can be used to roll the dice, show the last roll, roll the dice multiple times, calculate the average roll value, and count the number of occurrences of a specific value.

#### Class Attributes

* sides: An integer representing the number of sides on the dice.
* last_roll: The last value rolled on the dice. It is initially set to nil until the dice is rolled for the first time.

#### Methods

`initialize(sides)`
The constructor method that initializes a new instance of Dice. The sides parameter must be a positive integer, and the method raises an ArgumentError if the input is invalid.

##### Input

* sides (Integer): The number of sides on the dice.

```Ruby
# Example Usage
dice = Dice.new(6) # Creates a dice with 6 sides
```

`roll`
The method that rolls the dice, generating a random value between 1 and the number of sides on the dice. It also updates the last_roll attribute with the value rolled.

##### Output

* (Integer): The value rolled on the dice.

```Ruby
# Example Usage
dice.roll # Rolls the dice and returns a random value between 1 and 6
```

`show_last_roll`
The method that shows the value of the last roll of the dice. If the dice has not been rolled yet, the method returns "No previous roll."

`Output`

* (String): A message showing the value of the last roll or indicating that there was no previous roll.

```Ruby
# Example Usage
dice.roll # Rolls the dice and returns a random value between 1 and 6
dice.show_last_roll # Returns "Last roll: 4"
```

`roll_multiple(times)`
The method that rolls the dice multiple times and returns an array of the values rolled. The times parameter must be a positive integer, and the method raises an ArgumentError if the input is invalid.

`Input:`

times (Integer): The number of times to roll the dice.
`Output:`

(Array): An array containing the values rolled on the dice.

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/T0ren4ik/probabilityTheory>.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
