require 'test/unit'
require_relative '../lib/probabilityTheory/cart'

class DeckOfCardsTest < Test::Unit::TestCase
  def test_initialize_with_valid_count
    deck1 = DeckOfCards.new(36)
    deck2 = DeckOfCards.new(52)

    assert_not_nil deck1
    assert_not_nil deck2
    assert_equal 36, deck1.cards.length
    assert_equal 52, deck2.cards.length
  end

  def test_initialize_with_invalid_count
    assert_raise ArgumentError do
      DeckOfCards.new(24)
    end
  end

  def test_shuffle_cards
    deck = DeckOfCards.new(52)
    before_shuffle = deck.cards.dup
    deck.shuffle_cards
    after_shuffle = deck.cards.dup

    assert_not_equal before_shuffle, after_shuffle
    assert_equal before_shuffle.sort, after_shuffle.sort
  end

  def test_take_card
    deck = DeckOfCards.new(52)
    card1 = deck.take_card
    card2 = deck.take_card

    assert_not_nil card1
    assert_not_nil card2
    assert_not_equal card1, card2
    assert_equal 50, deck.cards.length
  end

  def test_take_card_from_empty_deck
    deck = DeckOfCards.new(52)

    52.times do
      deck.take_card
    end

    assert_raise RuntimeError do
      deck.take_card
    end
  end

  def test_pull_cards
    deck = DeckOfCards.new(52)
    cards = deck.pull_cards(5)

    assert_not_nil cards
    assert_equal 5, cards.length
    assert_equal 47, deck.cards.length
  end

  def test_pull_more_cards_than_in_deck
    deck = DeckOfCards.new(52)

    assert_raise ArgumentError do
      deck.pull_cards(53)
    end
  end

  def test_back_to_deck
    deck = DeckOfCards.new(52)
    card = deck.take_card

    deck.back_to_deck(card)

    assert_equal 52, deck.cards.length
    assert_equal card, deck.take_card
  end

  def test_back_to_deck_already_in_deck
    deck = DeckOfCards.new(52)
    card = deck.take_card

    assert_raise ArgumentError do
      deck.back_to_deck(card)
    end
  end
end