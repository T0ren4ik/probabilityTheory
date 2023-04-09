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
    @curr_idxs = @start_idxs = nil
    @end_not_reached = true
  end

  def next
    ret = get_current
    index_forward if ret
    ret
  end

  def restart
    @curr_idxs.fill {|i| @start_idxs[i]}
    @end_not_reached = true
  end

  def take n=1
    restart
    ret = []
    (1..n).each { ret << self.next }
    ret
  end

  def to_a
    restart
    ret = []
    loop do
      next_item = self.next
      break if !next_item
      ret << next_item
    end
    ret
  end

  def count
    restart
    ret = 0
    if block_given?
      loop do 
        next_el = self.next
        break if !next_el
        ret += 1 if yield next_el
      end
    else
      loop do 
        next_el = self.next
        break if !next_el
        ret += 1
      end
    end
    ret
  end

  def map &block
    Map.new self, &block
  end

  def filter &block
    Filter.new self, &block
  end

  private

  def get_current
    @end_not_reached ? @curr_idxs.map {|i| @src[i]} : nil
  end

  def index_forward
    # Should set @end_not_reached to false if unable to move forward
    raise NotImplementedError
  end

end

class HigherOrderEnumerator < BaseEnumerator
  
  def initialize src_enum, &block
    raise ArgumentError('Implemented only for BaseEnumerator objects') unless src_enum.is_a? BaseEnumerator 
    @block = block
    @src_enum = src_enum
  end

  def restart
    @src_enum.restart
  end

  def next
    raise NotImplementedError
  end

end

class Map < HigherOrderEnumerator

  def next
    arg = @src_enum.next
    arg ? @block.call(arg) : nil
  end

end

class Filter < HigherOrderEnumerator

  def next
    arg = nil
    loop do
      arg = @src_enum.next
      break if !arg || (@block.call(arg))
    end
    arg
  end

end
