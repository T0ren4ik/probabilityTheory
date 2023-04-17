require_relative '../lib/probabilityTheory/GameMachine'
require 'test/unit'


class TestGameMachine < Test::Unit::TestCase
  def test_1line_diag
    cash_start = 3000
    symbols = ['^', '*', '#', '$', '7']
    probability_symbols = [0.11, 0.14, 0.2, 0.05, 0.5]
    rate_bet = 1.25
    casino = GameMachine.new(cash_start, symbols, probability_symbols, rate_bet)

    casino.set_bet(200)
    srand 1256 # 1 diagonal line
    casino.spin


    assert_equal casino.get_balance, 3250
    casino.spin
  end


  def test_4lines
    cash_start = 2000
    symbols = ['^', '*', '#', '$', '7']
    probability_symbols = [0.11, 0.14, 0.2, 0.05, 0.5]
    rate_bet = 1.25
    casino = GameMachine.new(cash_start, symbols, probability_symbols, rate_bet)

    casino.set_bet(300)
    srand 500 # 1 diagonal line
    casino.spin

    assert_equal casino.get_balance, 3500
  end

end
