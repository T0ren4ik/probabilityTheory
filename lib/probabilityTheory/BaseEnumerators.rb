class BaseEnumerator
  def initialize src
    if (src.is_a? Integer) && (src.positive)
      @src = (1..src).to_a
    elsif src.is_a? String
      @src = src.chars
    elsif src.is_a? Array
      @src = src.dup
    end
    @src.sort!
    @start_idxs = (0...src.size).to_a
    @curr_idxs = @start_idxs.dup
  end

  def take n=1
    ret, = get_n(@start_idxs, n)
    ret
  end

  def next
    if @curr_idxs 
      ret, @curr_idxs = get_n(@curr_idxs, 1)
    else
      ret = nil
    end
    ret
  end

  def to_a
    @curr_idxs = @start_idxs.dup
    ret = []
    loop do 
      next_el = self.next
      break if !next_el
      ret << next_el
    end
    ret
  end

  def count
    @curr_idxs = @start_idxs.dup
    ret = 0
    if block_given?
      loop do 
        next_el = self.next
        break if !next_el
        ret += 1 if yield next_el
      end
    else 
      if @total_count
        return @total_count
      end
      loop do 
        next_el = self.next
        break if !next_el
        ret += 1
      end
    end
    ret
  end

  def map
  end

  def filter
  end

  private

  def get_by_idxs idxs
    idxs.map {|i| @src[i]}
  end

  def get_n idxs, n
    ret = []
    n.times do
      ret << get_by_idxs(idxs)
      idxs = self.class.index_arr_forward(idxs)
    end
    ret = ret[0] if n == 1
    [ret, idxs]
  end

  # CLASS METHODS

  class << self
    def index_arr_forward index_arr
      raise NotImplementedError
    end
  end
end

# class Map < BaseEnumerator

#   def initialize src, &block
#     raise ArgumentError('Implemented for two types only: BaseEnumerator and Array') unless (src.is_a? Array) || (src.is_a? BaseEnumerator) 
#     @src = src
#     @block = block
#   end

#   def next
#     @block.call @src.next
#   end

# end

# class Filter < BaseEnumerator

#   def initialize src, &block
#     @src = src
#     @block = block
#   end

# end
