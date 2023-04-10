require 'test/unit'
require_relative '../lib/probabilityTheory/dice'

class TestDice < Test::Unit::TestCase
  def setup
    srand(1234)
    @dice = Dice.new(6)
  end

  def test_initialize_with_valid_sides
    assert_nothing_raised { Dice.new(6) }
    assert_nothing_raised { Dice.new(20) }
    assert_nothing_raised { Dice.new(100) }
  end

  def test_initialize_with_invalid_sides
    assert_raise(ArgumentError) { Dice.new(-1) }
    assert_raise(ArgumentError) { Dice.new(0) }
    assert_raise(ArgumentError) { Dice.new(nil) }
    assert_raise(ArgumentError) { Dice.new('string') }
  end

  def test_roll_returns_value_within_range
    result = @dice.roll
    assert(result.is_a?(Integer))
    assert(result >= 1 && result <= 6)
  end

  def test_show_last_roll_with_no_previous_roll
    assert_equal("No previous roll.", @dice.show_last_roll)
  end


  def test_roll_multiple_with_valid_times
    result = @dice.roll_multiple(5)
    assert(result.is_a?(Array))
    assert_equal(5, result.size)
    result.each do |value|
      assert(value >= 1 && value <= 6)
    end
  end

  def test_roll_multiple_with_invalid_times
    assert_raise(ArgumentError) { @dice.roll_multiple(-1) }
    assert_raise(ArgumentError) { @dice.roll_multiple(nil) }
    assert_raise(ArgumentError) { @dice.roll_multiple('string') }
  end

  def test_average_roll_with_valid_times
    result = @dice.average_roll(5)
    assert(result >= 1 && result <= 6)
  end

  def test_average_roll_with_invalid_times
    assert_raise(ArgumentError) { @dice.average_roll(-1) }
    assert_raise(ArgumentError) { @dice.average_roll(nil) }
    assert_raise(ArgumentError) { @dice.average_roll('string') }
  end

  def test_count_occurrences_with_valid_value_and_times
    result = @dice.count_occurrences(3, 5)
    assert(result.is_a?(Integer))
    assert_equal(0, result)
  end

  def test_count_occurrences_with_invalid_value_and_times
    assert_raise(ArgumentError) { @dice.count_occurrences(-1, 5) }
    assert_raise(ArgumentError) { @dice.count_occurrences(3, -1) }
    assert_raise(ArgumentError) { @dice.count_occurrences(nil, 5) }
    assert_raise(ArgumentError) { @dice.count_occurrences('string', 5) }
  end
end