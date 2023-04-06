module Features
  # мат.ожидание
  def expected_value(data)
    raise ArgumentError, 'Input data should be a non-empty array of pairs of numbers' unless data.is_a?(Array) && data.all? { |arr| arr.is_a?(Array) && arr.size == 2 && arr.all? { |el| el.is_a?(Numeric) } }
    
    sum = 0
    data.each do |value, probability|
      sum += value * probability
    end
    
    sum
  end

  # дисперсия  
  def variance(data)
    mean = expected_value(data)
    return nil if mean.nil?
    
    sum = 0
    data.each do |value, probability|
      sum += probability * (value - mean)**2
    end
    
    sum
  end

  # функциa распределения вероятностей
  def create_cdf(data)
    raise ArgumentError, 'Data should be a non-empty array' unless data.is_a?(Array) && !data.empty?
    cdf = []
    sum = 0
    data.each do |x, p|
      raise ArgumentError, 'Probability value should be a number between 0 and 1' unless p.is_a?(Numeric) && p.between?(0, 1)
      sum += p
      cdf << [x, sum]
    end
    cdf
  end
  
  # Ковариационная матрица и ковариация
  def covariance(x, y)
    raise ArgumentError, 'Input arrays should have the same size' unless x.size == y.size
    raise ArgumentError, 'Input arrays should contain only numeric values' unless x.all? { |value| value.is_a?(Numeric) } && y.all? { |value| value.is_a?(Numeric) }
    
    n = x.size.to_f
    mean_x = x.sum / n
    mean_y = y.sum / n
    sum = x.zip(y).reduce(0) {|s, (x_i, y_i)| s += (x_i - mean_x) * (y_i - mean_y)}
    sum / (n - 1)
  end
  
  def covariance_matrix(data)
    raise ArgumentError, 'Input data should be a non-empty array of arrays' unless data.is_a?(Array) && !data.empty? && data.all? { |row| row.is_a?(Array) }
    n = data.size
    raise ArgumentError, 'Input arrays should have the same size' unless data.all? { |row| row.size == n }
    raise ArgumentError, 'Input arrays should contain only numeric values' unless data.flatten.all? { |value| value.is_a?(Numeric) }
  
    matrix = Array.new(n) { Array.new(n) }

    (0...n).each do |i|
      (0...n).each do |j|
        cov = covariance(data[i], data[j])
        matrix[i][j] = cov / (n - 1)
      end
    end

    matrix
  end

  # Формула Байеса
  def total_probability(events, probabilities)
    unless events.is_a?(Array) && probabilities.is_a?(Array) && events.size == probabilities.size && events.all? { |e| e.is_a?(Numeric) } && probabilities.all? { |p| p.is_a?(Numeric) }
      raise ArgumentError, "Invalid input: expected two arrays of numeric values with the same size"
    end
    
    sum = events.reduce(0) { |sum, p| sum + p }
    raise ArgumentError, "Events probabilities don't add up to 1" unless (sum - 1).abs < 1e-10
    
    sum
  end
  
  def bayes_theorem(event, events, probabilities)
    raise ArgumentError, "Invalid input: expected two arrays of numeric values with the same size" unless events.is_a?(Array) && probabilities.is_a?(Array) && events.size == probabilities.size
    raise ArgumentError, "Invalid index: event index out of bounds" unless event >= 0 && event < events.size

    denominator = total_probability(events, probabilities)
    events[event] * probabilities[event] / denominator
  end

  # Повторные испытания. формула Бернулли
  def bernoulli(p, k, n)
    raise ArgumentError, 'p should be a number between 0 and 1' unless p.is_a?(Numeric) && p >= 0 && p <= 1
    raise ArgumentError, 'k should be an integer greater than or equal to 0' unless k.is_a?(Integer) && k >= 0
    raise ArgumentError, 'n should be an integer greater than or equal to 0' unless n.is_a?(Integer) && n >= 0
  
    c = Math.gamma(n+1) / (Math.gamma(k+1) * Math.gamma(n-k+1)) # c помошью комбинаторики
    c * p**k * (1 - p)**(n - k)
  end

  # Локальная теорема Лапласа
  def local_laplace(k, n, p)
    raise ArgumentError, 'n should be a positive integer' unless n.is_a?(Integer) && n > 0
    raise ArgumentError, 'p should be a numeric value between 0 and 1' unless p.is_a?(Numeric) && p.between?(0, 1)
    
    q = 1 - p
    mu = n * p
    sigma = Math.sqrt(n * p * q)
    1 / (sigma * Math.sqrt(2*Math::PI)) * Math.exp(-((k - mu)**2) / (2 * sigma**2))
  end

  # Интегральная теорема Лапласа
  def integral_laplace(a, b, n, p)
    raise "Invalid input: a should be less than or equal to b" if a > b
    raise "Invalid input: n should be positive" if n <= 0
    raise "Invalid input: p should be between 0 and 1" if p < 0 || p > 1
  
    q = 1 - p
    mu = n * p
    sigma = Math.sqrt(n * p * q)
    x1 = (a - mu) / (sigma * Math.sqrt(2))
    x2 = (b - mu) / (sigma * Math.sqrt(2))
    (Math.erf(x2) - Math.erf(x1)) / 2
  end

  # Функция для вычисления условной вероятности
  def conditional_probability(outcomes, a_outcomes, b_outcomes)
    p_a = a_outcomes.to_f / outcomes.to_f
    p_b = b_outcomes.to_f / outcomes.to_f
    p_ab = p_a*p_b
    p_ab/p_b
  end

  # Функция для вычисления произведения совместных событий
  def product_joint(outcomes, a_outcomes, b_outcomes)
    p_a = a_outcomes.to_f / outcomes.to_f
    p_a*conditional_probability(outcomes, a_outcomes, b_outcomes)
  end

  # Функция для вычисления произведения несовместных событий
  def product_incompatible(outcomes, a_outcomes, b_outcomes)
    p_a = a_outcomes.to_f / outcomes.to_f
    p_b = b_outcomes.to_f / outcomes.to_f
    p_a*p_b
  end

  # Функция для вычисления суммы несовместных событий
  def sum_incompatible(outcomes, a_outcomes, b_outcomes)
    p_a = a_outcomes.to_f / outcomes.to_f
    p_b = b_outcomes.to_f / outcomes.to_f
    p_a + p_b
  end

  # Функция для вычисления суммы совместных событий
  def sum_joint(outcomes, a_outcomes, b_outcomes)
    p_a = a_outcomes.to_f / outcomes.to_f
    p_b = b_outcomes.to_f / outcomes.to_f
    p_a + p_b - p_a*p_b
  end
end
