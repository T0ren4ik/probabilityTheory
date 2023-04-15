require_relative './BaseEnumerators.rb'

# Module Scheme

# util funcs
# (cached) factorial (n)

# base and util classes
# BaseEnumerator
# Map, Filter, TakeWhile, DropWhile

# API funcs
# permutations_count(n, [k1, k2, ...])
# placements_count(n, k)
# replace_placements_count(n, k)
# combinations_count(n, k)
# replace_combinations_count(n, k)

# API classes
# Permutations, Placements, Combinations
# ReplacePlacements, ReplaceCombinations
# CartesianProduct, Powerset
# shared public methods: to_a, filter, map, take_while, drop_while,
#   count (with optional block), next, restart

module Combinatorics
  @@fact_cache = [1, 1]
  def factorial(n)
    raise ArgumentError, "Wrong argument for factorial: #{n}" if (not n.is_a? Integer) || n.negative?
    @@fact_cache[n] ||= n * factorial(n - 1)
  end

  def permutations_count(n, *ks)
    raise "Too many repetitions: repetitions sum #{ks.sum}, but n is #{n}" if ks.sum > n
    factorial(n) / ks.inject(1) {|acc, k| acc * factorial(k)}
  end

  def placements_count(n, k)
    permutations_count(n, n - k)
  end

  def replace_placements_count(n, k)
    raise ArgumentError, "Wrong arguments for placements count: #{n} #{k}" unless !n.negative? && !k.negative?
    n ** k
  end

  def combinations_count(n, k)
    permutations_count(n, n - k, k)
  end

  def replace_combinations_count(n, k)
    combinations_count(n + k - 1, k)
  end

  BaseEnumerator = BaseEnumerator::BaseEnumerator

  class Permutations < BaseEnumerator

    def initialize src
      super src
      # the strange assignment needed to handle permutations with replace
      @start_index = (0...src.size).map {|i| @src.index(@src[i])}
      @curr_index = @start_index.dup
    end

    def restart
      @curr_index.fill {|i| @start_index[i]}
      @end_not_reached = self.set_end_not_reached
    end

    private

    def set_end_not_reached
      # Supposed to return false if bad initialize arguments
      (@src.size > 0) && (!@k || @k > 0)
    end
  
    def get_current
      @end_not_reached ? @curr_index.map {|i| @src[i]} : nil
    end

    def index_forward
      # Narayana algorithm https://ru.wikipedia.org/wiki/%D0%90%D0%BB%D0%B3%D0%BE%D1%80%D0%B8%D1%82%D0%BC_%D0%9D%D0%B0%D1%80%D0%B0%D0%B9%D0%B0%D0%BD%D1%8B
      idxs = (0...@curr_index.size).to_a.reverse
      j = idxs[1..-1].find {|idx| @curr_index[idx] < @curr_index[idx + 1]}
      if j
        l = idxs.find {|idx| @curr_index[idx] > @curr_index[j]}
        @curr_index[j], @curr_index[l] = @curr_index[l], @curr_index[j]
        @curr_index[j+1..-1] = @curr_index[j+1..-1].reverse
      else
        @end_not_reached = false
      end
    end

  end

  class Placements < Permutations

    def initialize src, k
      BaseEnumerator.instance_method(:initialize).bind(self).call(src)
      raise NotImplementedError, "Currently class Placements does not support repetitions in the source iterable" if @src.uniq.size < @src.size
      raise ArgumentError, "Cannot built placements per #{k} from #{@src.size}" if k < 0 || k > @src.size
      @k = k
      @start_index = (0...src.size).map {|i| i >= @k ? @k : i}
      @curr_index = @start_index.dup
    end

    private

    def get_current
      if @end_not_reached
        shrinked = @src.zip(@curr_index).filter {|el, i| i < @k}
        @curr_index.select {|i| i < @k}.map {|idx| shrinked[idx].first}
      end
    end

  end

  class ReplacePlacements < Permutations

    def initialize src, k
      BaseEnumerator.instance_method(:initialize).bind(self).call(src)
      raise ArgumentError, "Cannot built replace placements per #{k} from #{@src.size}" if k < 0
      @src.uniq!
      @k, @n = k, @src.size
      @start_index = Array.new @k, 0
      @max_index = Array.new @k, @n - 1
      @curr_index = @start_index.dup
    end

    private

    def index_forward
      if @curr_index != @max_index
        plus_one_to_next = true
        @curr_index.each_with_index.reverse_each { |el, i|
          if plus_one_to_next
            plus_one_to_next, @curr_index[i] = (el + 1).divmod(@max_index[i] + 1)
            plus_one_to_next = (plus_one_to_next == 1)
          end
        }
      else
        @end_not_reached = false
      end
    end

  end

  class Combinations < Permutations

    def initialize src, k
      BaseEnumerator.instance_method(:initialize).bind(self).call(src)
      raise NotImplementedError, "Currently class Combinations does not support repetitions in the source iterable" if @src.uniq.size < @src.size
      raise ArgumentError, "Cannot built combinations per #{k} from #{@src.size}" if k < 0 || k > @src.size
      @k = k
      @start_index = (0...src.size).map {|i| i >= @k ? 1 : 0}
      @curr_index = @start_index.dup
    end

    private

    def get_current
      @src.zip(@curr_index).filter {|el, i| i == 0}.map {|p| p.first} if @end_not_reached
    end
 
  end

  class ReplaceCombinations < Permutations

    def initialize src, k
      BaseEnumerator.instance_method(:initialize).bind(self).call(src)
      raise ArgumentError, "Cannot built replace combinations per #{k} from #{@src.size}" if k < 0
      @k = k
      @src.uniq!
      @start_index = (0...(@src.size + @k  - 1)).map {|i| i >= @k ? 1 : 0}
      @curr_index = @start_index.dup
    end

    private

    def get_current
      if @end_not_reached
        src_idx, q = 0, 0
        ret = []
        @curr_index.each {|i|
          if i == 1
            q.times do
              ret << @src[src_idx]
            end
            src_idx, q = src_idx + 1, 0
          else
            q += 1
          end
        }
        q.times do
          ret << @src[src_idx]
        end
        ret
      end
    end

  end

  class CartesianProduct < ReplacePlacements

    def initialize *source_arrays
      @max_index = []
      source_arrays.each_with_index { |iter, i|
        source_arrays[i] = iter.chars if iter.is_a? String
        if !(source_arrays[i].is_a? Array)
          raise ArgumentError, "CartesianProduct argument should be a string or an Array, but #{source_arrays[i]} was received"
        end
        source_arrays[i].uniq!
        @max_index << source_arrays[i].size - 1
      }
      @src = source_arrays
      @start_index = Array.new @src.size, 0
      @curr_index = @start_index.dup
      @end_not_reached = self.set_end_not_reached
    end

    private

    def set_end_not_reached
      # Supposed to return false if bad initialize arguments
      (@src.all? {|arr| arr.size > 0}) && (@src.size > 0)
    end

    def get_current
      if @end_not_reached
        @curr_index.each_with_index.map {|ind, i| @src[i][ind]}
      end
    end

  end

  class Powerset < ReplacePlacements

    def initialize src
      BaseEnumerator.instance_method(:initialize).bind(self).call(src)
      raise NotImplementedError, "Currently class Powerset does not support repetitions in the source iterable" if @src.uniq.size < @src.size
      @src = @src.reverse
      @start_index = Array.new @src.size, 0
      @max_index = Array.new @src.size, 1
      @curr_index = @start_index.dup
    end

    private

    def get_current
      if @end_not_reached
        @curr_index.each_with_index.map {|ind, i| ind == 1 ? @src[i] : nil}.compact
      end
    end

  end

end


# def local_test

#   include Combinatorics

#   # obj = CartesianProduct.new '1234', [1, 2], ['12', 30]
#   # 40.times do
#   #   v = obj.next
#   #   puts v.inspect if v
#   #   puts 'Hi There' if !v
#   # end

#   # obj = Powerset.new '12345'
#   # 40.times do
#   #   v = obj.next
#   #   puts v.inspect if v
#   #   puts 'Hi There' if !v
#   # end

#   puts Permutations.new([1]).to_a.inspect

# end

# local_test
