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
    permutations_with_replace(n, n - k)
  end

  def placements_with_replace(n, k)
    n ** k
  end

  def combinations(n, k)
    permutations_with_replace(n, n - k, k)
  end

  def combinations_with_replace(n, k)
    combinations(n + k - 1, k - 1)
  end

  class Permutations < BaseEnumerator
  
    def initialize src
      super src
      # this needed to handle permutations with replace
      @start_idxs = @start_idxs.map {|i| @src.index(@src[i])}
      # @total_count = permutations(@src.size)
    end
  
    # CLASS METHODS
  
    class << self
      def index_arr_forward index_arr
        # Narayana algorithm
        index_arr = index_arr.dup
        idxs = (0...index_arr.size).to_a.reverse
        j = idxs[1..-1].find {|idx| index_arr[idx] < index_arr[idx + 1]}
        if j
          l = idxs.find {|idx| index_arr[idx] > index_arr[j]}
          index_arr[j], index_arr[l] = index_arr[l], index_arr[j]
          index_arr[0..j] + index_arr[j+1..-1].reverse
        else
          # TODO
          nil
        end
      end
    end
  
  end
  
  class Placements < Permutations
    
    def initialize src, k
      BaseEnumerator.instance_method(:initialize).bind(self).call(src)
      raise NotImplementedError, "Currently class Placements does not support repetitions in the source iterable" if @src.uniq.size < @start_idxs.size
      @k = k
      @start_idxs.map! {|i| i >= @k ? @k : i}
    end
  
    private
  
    def get_by_idxs idxs
      shrinked = @src.zip(idxs).filter {|el, i| i < @k}
      idxs.select {|i| i < @k}.map {|idx| shrinked[idx].first}
    end
  
  end
  
  class Combinations < Permutations
    
    def initialize src, k
      BaseEnumerator.instance_method(:initialize).bind(self).call(src)
      raise NotImplementedError, "Currently class Combinations does not support repetitions in the source iterable" if @src.uniq.size < @start_idxs.size
      @k = k
      @start_idxs.map! {|i| i >= @k ? 1 : 0}
      puts @start_idxs.inspect
    end
  
    private
  
    def get_by_idxs idxs
      @src.zip(idxs).filter {|el, i| i == 0}.map {|p| p.first}
    end
  
  end

end

# def local_test
#   obj = Combinations.new '12345', 2
#   puts obj.to_a.inspect
# end

# local_test
