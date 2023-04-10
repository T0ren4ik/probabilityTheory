require_relative '../lib/probabilityTheory/combinatorics'
require 'test/unit'

require 'benchmark'

include Combinatorics

class TestCombinatorics < Test::Unit::TestCase
  def test_factorial
    assert_raise(ArgumentError) { factorial('Hello') }
    assert_raise(ArgumentError) { factorial(-1) }
    assert_equal 1, factorial(0)
    assert_equal 1, factorial(1)
    assert_equal 2, factorial(2)
    assert_equal 6, factorial(3)
    assert_equal 5040, factorial(7)
  end

  def test_perms_count
    obj = Permutations.new '1234'
    assert_equal(24, obj.count)
    assert_equal(6, obj.count {|perm| perm[0] == '1'})
    assert_equal(10, obj.count {|perm| (perm[3] == '1') || (perm[1] == '3')})
  end

  def test_perms_to_a
    obj = Permutations.new '123'
    assert_equal([['1', '2', '3'],
                  ['1', '3', '2'],
                  ['2', '1', '3'], 
                  ['2', '3', '1'],
                  ['3', '1', '2'],
                  ['3', '2', '1']], obj.to_a)

  end

  def test_perms_take
    obj = Permutations.new '123'
    assert_equal([['1', '2', '3'],
                  ['1', '3', '2'],
                  ['2', '1', '3']], obj.take(3))
    
    # we can repeat
    assert_equal([['1', '2', '3'],
                  ['1', '3', '2'],
                  ['2', '1', '3']], obj.take(3))
    
    # nils if trying to take too much
    assert_equal([['1', '2', '3'],
                  ['1', '3', '2'],
                  ['2', '1', '3'], 
                  ['2', '3', '1'],
                  ['3', '1', '2'],
                  ['3', '2', '1'],
                  nil, nil, nil], obj.take(9))

  end

  def test_replace_perms_also_work
    obj = Permutations.new '1121'
    assert_equal(4, obj.count)
    assert_equal(2, obj.count {|perm| perm[0] == perm[1]})
    assert_equal([['1', '1', '1', '2'],
                  ['1', '1', '2', '1'],
                  ['1', '2', '1', '1'], 
                  ['2', '1', '1', '1'],], obj.to_a)
  end

  def test_placements_work
    obj = Placements.new '1234', 2
    assert_equal(12, obj.count)
    assert_equal(3, obj.count {|p| p[0].to_i - p[1].to_i == 1})
    
    obj = Placements.new '123', 2
    assert_equal(['12', '13', '21',
                  '23', '31', '32'], obj.to_a.map {|arr| arr.join}.sort)
  end

  def test_replace_placements_work
    obj = ReplacePlacements.new '12345', 3
    assert_equal(125, obj.count)
    assert_equal(20, obj.count {|p| p[0].to_i - p[1].to_i == 1})
    
    obj = ReplacePlacements.new '123', 2
    assert_equal(['11', '12', '13',
                  '21', '22', '23',
                  '31', '32', '33'], obj.to_a.map {|arr| arr.join})
  end

  def test_combinations_work
    obj = Combinations.new '123456', 3
    assert_equal(20, obj.count)
    assert_equal(10, obj.count {|p| p[0] == '1'})
    
    obj = Combinations.new '123', 2
    assert_equal(['12', '13', '23'], obj.to_a.map {|arr| arr.join}.sort)
  end
  
  def test_replace_combinations_work
    obj = ReplaceCombinations.new '123456', 3
    assert_equal(56, obj.count)
    assert_equal(21, obj.count {|p| p[0] == '1'})
    
    obj = ReplaceCombinations.new '123', 2
    assert_equal(['11', '12', '13', '22', '23', '33'], obj.to_a.map {|arr| arr.join})
  end

  def test_map_iterator
    map_obj = Placements.new((1..3).to_a, 2).map {|arr| 10 * arr[0] + arr[1]}
    
    # Map is Enumerator, not Array
    assert map_obj.is_a? BaseEnumerator
    assert_raise(NoMethodError) { map_obj[0] }

    # to_a method
    assert_equal([12, 13, 21, 23, 31, 32], map_obj.to_a.sort)

    # count method
    assert_equal(6, map_obj.count)
    assert_equal(4, map_obj.count {|x| x % 2 == 1})

    # maps can be chained
    map_obj = map_obj.map {|x| 10 * x}
    assert_equal([120, 130, 210, 230, 310, 320], map_obj.to_a.sort)
  end

  def test_filter_iterator
    filter_obj = Combinations.new((1..5).to_a, 3).filter {|arr| arr.sum >= 10}
    
    # Filter is Enumerator, not Array
    assert filter_obj.is_a? BaseEnumerator
    assert_raise(NoMethodError) { filter_obj[0] }

    # to_a method
    assert_equal([[1, 4, 5], [2, 3, 5], [2, 4, 5], [3, 4, 5]], filter_obj.to_a)

    # count method
    assert_equal(4, filter_obj.count)
    assert_equal(2, filter_obj.count {|arr| arr.reduce(:*) % 15 == 0})

    # filters can be chained
    filter_obj = filter_obj.filter {|arr| arr.reduce(:*) % 15 == 0}
    assert_equal([[2, 3, 5], [3, 4, 5]], filter_obj.to_a)
  end

  def test_filter_and_map_chain
    obj = Combinations.new((1..5).to_a, 3)

    map_filter_obj = obj.map {|arr| arr.reduce(:*)}.filter {|num| num % 15 == 0}
    assert_equal([15, 30, 60], map_filter_obj.to_a)

    filter_map_obj = obj.filter {|arr| arr.reduce(:*) % 15 == 0}.map {|arr| arr.reduce(:+)}
    assert_equal([9, 10, 12], filter_map_obj.to_a)

  end

end


def fact_performance_test
  puts "Cached factorial performance"
  puts "Measured while executing { factorial(900) } 3 times"
  
  time0 = Benchmark.measure {factorial(900)}.real
  time1 = Benchmark.measure {factorial(900)}.real
  time2 = Benchmark.measure {factorial(900)}.real
  
  puts "1st run: #{time0};\n2nd run: #{time1};\n3d run: #{time2}\n\n\n"
end

def enumerator_count_performance_test
  puts "Enumerator's .count method performance"
  puts "obj0: Permutations([1..6])"
  puts "obj0: Permutations([1..8])"
  puts "obj0: Permutations([1..10])"
  puts "Measured while executing { obj.count {|p| p[2] - p[0] < 2} } once for each"
  
  obj0 = Permutations.new((1..6).to_a)
  time0 = Benchmark.measure { obj0.count {|p| p[2] - p[0] < 2} }.real

  obj1 = Permutations.new((1..8).to_a)
  time1 = Benchmark.measure { obj1.count {|p| p[2] - p[0] < 2} }.real

  obj2 = Permutations.new((1..10).to_a)
  time2 = Benchmark.measure { obj2.count {|p| p[2] - p[0] < 2} }.real
  
  puts "Dependence on n.\nIf n = 6: #{time0};\nIf n = 8: #{time1};\nIf n = 10: #{time2}\n\n\n"
end


fact_performance_test
# enumerator_count_performance_test  # WARNING: Long test, about 30 seconds
