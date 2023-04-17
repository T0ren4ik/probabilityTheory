class GameMachine
  # кол-во монет;доступные символы(array));
  # вероятность выпадения символов; коэф выигрыша;
	def initialize(cash_available, symbols,
    probability_symbols, rate_bet)
		@cash_available = cash_available
		@symbols = symbols
    @probability_symbols = probability_symbols
    @rate_bet = rate_bet
    @bet = 0

    @probability_defualt_value = @probability_symbols.inject(0, :+)

    @screen = [['-','-','-'],
              ['-','-','-'],
              ['-','-','-']]
	end

# setter
  def set_bet(bet)
    if bet > @cash_available
      p 'Can`t afford this bet'
    else
      @bet = bet
    end
  end

# spin logic

  def rand_pick
    r = rand(0..100)
    prob_l = 0
    # смотрим в какую вероятность попадет
    for i in (0..@probability_symbols.length-1)
      # увеличиваем отрезок попадания
      prob_l += @probability_symbols[i]
      if r < prob_l*100
        return i
      end
    end
    return -1

  end

	def spin
    for i in (0..@screen.length-1)
      for j in (0..@screen[0].length-1)
        r = rand_pick
        @screen[i][j] = r
      end
    end

    lines_count = res_of_spin()
    if lines_count == 0
      p '=======Lose========='
      lose_logic()
    else
      p '=======Win(Lines: %d)=========' % [lines_count]
      win_logic(lines_count)
    end
    return @screen

	end

  def win_logic(lines_count)
    @cash_available += @bet * @rate_bet * lines_count
  end

  def lose_logic
    @cash_available -= @bet
  end
# подсчет очков (lines)
  def res_of_spin
    lines_count = 0
    m = @screen.length-1
    n = @screen[0].length-1
    #horizontal lines
    for i in (0..m)
      if @screen[i].uniq.size <= 1
        lines_count += 1
      end
    end
# m,n
    #vertical lines
    for j in (0..n)
      flag = true
      for i in (1..m)
        if @screen[i][j] != @screen[i-1][j]
        #  p '%d %d' % [i,j]
          flag = false
        end
      end
      if flag
        lines_count += 1
      end
    end

    #diagonal lines
    if @screen[0][0] == @screen[1][1] && @screen[1][1] == @screen[2][2]

      lines_count += 1
    end
    if @screen[0][2] == @screen[1][1] && @screen[1][1] == @screen[2][0]
      lines_count += 1
    end



    return lines_count
  end

# отображение экрана игры
  def show_screen
    for i in (0..@screen.length-1)
      for j in (0..@screen[0].length-1)
        print '   %s' % [@symbols[@screen[i][j]]]
      end
      puts
    end

  end


	def get_balance
		@cash_available
	end

	def print_status
    p '-----------------------------------------'
    p '-----------------------------------------'
    p '-----------------------------------------'
    p 'Balance: %d' % [@cash_available]
    p 'Symbols: %s' % [@symbols]
    p 'Probability symbols: %s' % [@probability_symbols]
    p 'Bet rate : %f' % [@rate_bet]
    p 'Current bet: %d' % [@bet]
    p '-----------------------------------------'
    p '-----------------------------------------'
    p '-----------------------------------------'
		return [@cash_available, @symbols, @probability_symbols, @rate_bet, @bet]
	end


end



def gaming(cash_start, symbols, probability_symbols, rate_bet)
  p 'Welcome to virtual >>GameMachine<<'

  casino = GameMachine.new(cash_start, symbols, probability_symbols, rate_bet)
  while true
    p 'Press 0 to leave the game'
    p 'Press 1 to Spin'
    p 'Press 2 to change bet'
    inp = gets.to_i
    p inp

    if inp == 0
      return -1
    elsif inp == 1
      casino.spin
      casino.show_screen
      casino.print_status
    elsif inp == 2
      print 'Put bet: '
      bet = gets
      casino.set_bet(bet.to_i)
    end

  end
end

# srand 1114 # 1 diagonal line

# cash_start = 3000
# symbols = ['^', '*', '#', '$', '7']
# probability_symbols = [0.11, 0.14, 0.2, 0.05, 0.5]
# rate_bet = 1.25

# p = gaming(cash_start, symbols, probability_symbols, rate_bet)
