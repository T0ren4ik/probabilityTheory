class DeckOfCards
  attr_accessor :cards

  def initialize(count)
    if count == 36
      numpic = ["6", "7", "8", "9", "10", "V", "D", "K", "T"]
    elsif count == 52
      numpic = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "V", "D", "K", "T"]
    else
      raise ArgumentError, "Invalid count of cards"
    end

    suits = ["spades", "clubs", "hearts", "diamonds"]
    @cards = suits.product(numpic).map(&:join)
  end

  def shuffle_cards
    @cards.shuffle!
  end

  def take_card
    raise RuntimeError, "The deck is empty" if @cards.length == 0

    @cards.pop
  end

  def pull_cards(number)
    raise ArgumentError, "Not enough cards in the deck" if @cards.length < number

    @cards.pop(number)
  end

  def back_to_deck(card)
    raise ArgumentError, "The card is already in the deck" if @cards.include?(card)

    @cards.push(card)
  end
end