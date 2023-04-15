module BaseEnumerator

  class BaseEnumerator
    def initialize src
      if (src.is_a? Integer) && (src.positive?)
        @src = (1..src).to_a
      elsif src.is_a? String
        @src = src.chars
      elsif src.is_a? Array
        @src = src.dup
      end
      @src.sort!
      @curr_index = @start_index = nil
      @end_not_reached = self.set_end_not_reached
    end

    def next
      ret = get_current
      index_forward if ret
      ret
    end

    def restart
      @curr_index = @start_index.dup
      @end_not_reached = self.set_end_not_reached
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
      EnumTools::Map.new self, &block
    end

    def filter &block
      EnumTools::Filter.new self, &block
    end

    def take_while &block
      EnumTools::TakeWhile.new self, &block
    end

    def drop_while &block
      EnumTools::DropWhile.new self, &block
    end

    private

    def set_end_not_reached
      # Supposed to return false if bad initialize arguments
      raise NotImplementedError
    end

    def get_current
      # WARNING: Should return nil if not @end_not_reached. Otherwise there would be endless loop
      raise NotImplementedError
    end

    def index_forward
      # WARNING: Should set @end_not_reached to false if unable to move forward. Otherwise there would be endless loop
      raise NotImplementedError
    end

  end

end

module EnumTools
  BaseEnumerator = BaseEnumerator::BaseEnumerator

  class HigherOrderEnumerator < BaseEnumerator

    def initialize src_enum, &block
      raise ArgumentError('Currently implemented only for BaseEnumerator instances') unless src_enum.is_a? BaseEnumerator
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

  class TakeWhile < HigherOrderEnumerator

    def initialize src_enum, &block
      super src_enum, &block
      @continue = true
    end

    def next
      if @continue
        arg = @src_enum.next
        @continue = arg && @block.call(arg)
        @continue ? arg : nil
      end
    end

    def restart
      @src_enum.restart
      @continue = true
    end
    
  end

  class DropWhile < HigherOrderEnumerator

    def initialize src_enum, &block
      super src_enum, &block
      @not_started = true
    end

    def next
      arg = @src_enum.next
      while @not_started and arg
        if !arg || !@block.call(arg)
          @not_started = false
        else
          arg = @src_enum.next
        end
      end
      arg
    end

    def restart
      @src_enum.restart
      @not_started = true
    end

  end

end
