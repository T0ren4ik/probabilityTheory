require 'benchmark'

require_relative './BaseEnumerators.rb' 

# Module Scheme

# util funcs
# (cached) factorial (n)

# base and util classes
# BaseEnumerator
# Map, Filter

# API funcs
# permutations (n, [k1, k2, ...])
# placements (n, k, with_replace: bool)
# combinations (n, k, with_replace: bool)

# API classes
# Permutations, Placements, Combinations
# ReplacePlacements, ReplaceCombinations
# CartesianProduct, PowerSet
# shared methods: to_a, filter, map, count (with optional block), (private) next
# shared attributes: src: array; start_idxs, curr_idxs: index array

module Combinatorics
  @@fact_cache = [1, 1]
  def factorial(n)
    raise ArgumentError, "Wrong argument for factorial: #{n}" if (not n.is_a? Integer) || n.negative?
    @@fact_cache[n] ||= n * factorial(n - 1)
  end

  def permutations(n, *ks)
    raise "Too many repetitions: repetitions sum #{ks.sum}, but n is #{n}" if ks.sum > n
    factorial(n) / ks.inject(1) {|acc, k| acc * factorial(k)}
  end

  def placements(n, k)
    permutations(n, n - k)
  end

  def placements_with_replace(n, k)
    n ** k
  end

  def combinations(n, k)
    permutations(n, n - k, k)
  end

  def combinations_with_replace(n, k)
    combinations(n + k - 1, k)
  end

  class Permutations < BaseEnumerator
  
    def initialize src
      super src
      # the strange assignment needed to handle permutations with replace
      @start_idxs = (0...src.size).map {|i| @src.index(@src[i])}
      @curr_idxs = @start_idxs.dup
      # @total_count = permutations(@src.size)
    end

    private
    
    def index_forward
      # Narayana algorithm https://ru.wikipedia.org/wiki/%D0%90%D0%BB%D0%B3%D0%BE%D1%80%D0%B8%D1%82%D0%BC_%D0%9D%D0%B0%D1%80%D0%B0%D0%B9%D0%B0%D0%BD%D1%8B
      idxs = (0...@curr_idxs.size).to_a.reverse
      j = idxs[1..-1].find {|idx| @curr_idxs[idx] < @curr_idxs[idx + 1]}
      if j
        l = idxs.find {|idx| @curr_idxs[idx] > @curr_idxs[j]}
        @curr_idxs[j], @curr_idxs[l] = @curr_idxs[l], @curr_idxs[j]
        @curr_idxs[j+1..-1] = @curr_idxs[j+1..-1].reverse
      else
        @end_not_reached = false
      end
    end
  
  end
  
  class Placements < Permutations
    
    def initialize src, k
      BaseEnumerator.instance_method(:initialize).bind(self).call(src)
      raise NotImplementedError, "Currently class Placements does not support repetitions in the source iterable" if @src.uniq.size < @src.size
      @k = k
      @start_idxs = (0...src.size).map {|i| i >= @k ? @k : i}
      @curr_idxs = @start_idxs.dup
    end
  
    private
  
    def get_current
      if @end_not_reached
        shrinked = @src.zip(@curr_idxs).filter {|el, i| i < @k}
        return @curr_idxs.select {|i| i < @k}.map {|idx| shrinked[idx].first}
      end
    end
  
  end

  class ReplacePlacements < Permutations
    
    def initialize src, k
      BaseEnumerator.instance_method(:initialize).bind(self).call(src)
      @src.uniq!
      @k, @n = k, @src.size
      @start_idxs = Array.new @k, 0
      @curr_idxs = @start_idxs.dup
    end
  
    private

    def index_forward
      if @curr_idxs.min < @n - 1
        plus_one_to_next = true
        @curr_idxs.each_with_index.reverse_each { |el, i|
          if plus_one_to_next
            plus_one_to_next, @curr_idxs[i] = (el + 1).divmod @n
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
      @k = k
      @start_idxs = (0...src.size).map {|i| i >= @k ? 1 : 0}
      @curr_idxs = @start_idxs.dup
    end
  
    private
  
    def get_current
      @src.zip(@curr_idxs).filter {|el, i| i == 0}.map {|p| p.first} if @end_not_reached
    end
  
  end

  class ReplaceCombinations < Permutations
    
    def initialize src, k
      BaseEnumerator.instance_method(:initialize).bind(self).call(src)
      @k = k
      @src.uniq!
      @start_idxs = (0...(@src.size + @k  - 1)).map {|i| i >= @k ? 1 : 0}
      @curr_idxs = @start_idxs.dup
    end
  
    private
  
    def get_current
      if @end_not_reached
        src_idx, q = 0, 0
        ret = []
        @curr_idxs.each {|i|
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

end

# include Combinatorics

# def local_test
#   # obj = Combinations.new '12345', 2
#   # puts obj.to_a.inspect

#   # obj = Placements.new '1234', 2
#   # # 30.times do
#   # #   v = obj.next
#   # #   puts v.inspect if v
#   # #   puts 'Hi There' if !v
#   # # end
#   # # puts obj.count

#   # obj = ReplaceCombinations.new '123456', 3
#   # puts combinations_with_replace(6, 3)

#   obj = ReplacePlacements.new '1234', 2
#   20.times do
#     v = obj.next
#     puts v.inspect if v
#     puts 'Hi There' if !v
#   end

# end

# local_test
