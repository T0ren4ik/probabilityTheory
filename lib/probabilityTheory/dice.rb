class Dice
  def initialize(sides)
    raise ArgumentError, "Sides must be a positive integer" unless sides.is_a?(Integer) && sides > 0
    @sides = sides
    @last_roll = nil
  end

  def roll
    @last_roll = rand(1..@sides)
  end

  def show_last_roll
    if @last_roll.nil?
      "No previous roll."
    else
      "Last roll: #{@last_roll}"
    end
  end

  def roll_multiple(times)
    raise ArgumentError, "Times must be a positive integer" unless times.is_a?(Integer) && times > 0
    rolls = []
    times.times do
      rolls << roll
    end
    rolls
  end

  def average_roll(times)
    raise ArgumentError, "Times must be a positive integer" unless times.is_a?(Integer) && times > 0
    sum = 0
    times.times do # бросаем кубик times раз, чтобы получить среднее значение
      sum += roll
    end
    sum / times
  end
  
  def count_occurrences(value, times)
    raise ArgumentError, "Value must be a positive integer" unless value.is_a?(Integer) && value > 0
    raise ArgumentError, "Times must be a positive integer" unless times.is_a?(Integer) && times > 0
    count = 0
    times.times do
      count += 1 if roll == value
    end
    count
  end

end
