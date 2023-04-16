require_relative '../lib/probabilityTheory/combinatorics'
require 'test/unit'

require 'benchmark'

include Combinatorics

class TestCombinatorics < Test::Unit::TestCase
  # util functions
  def test_factorial
    assert_raise(ArgumentError) { factorial('Hello') }
    assert_raise(ArgumentError) { factorial(-1) }
    assert_equal 1, factorial(0)
    assert_equal 1, factorial(1)
    assert_equal 2, factorial(2)
    assert_equal 6, factorial(3)
    assert_equal 5040, factorial(7)
  end

  # API functions
  def test_permutations_count
    assert_raise(ArgumentError) { permutations_count('Hello') }
    assert_raise(RuntimeError) { permutations_count(-1) }
    assert_equal 1, permutations_count(0)
    assert_equal 1, permutations_count(1)
    assert_equal 2, permutations_count(2)
    assert_equal 6, permutations_count(3)
    assert_equal 5040, permutations_count(7)
  end

  def test_placements_count
    assert_raise(ArgumentError) {placements_count(0, 3)}
    assert_equal 1, placements_count(1, 1)
    assert_equal 2, placements_count(2, 1)
    assert_equal 6, placements_count(3, 2)
    assert_equal 56, placements_count(8, 2)
    assert_equal 720, placements_count(10, 3)
  end

  def test_replace_placements_count
    assert_equal 0, replace_placements_count(0, 3)
    assert_equal 1, replace_placements_count(1, 3)
    assert_equal 1, replace_placements_count(3, 0)
    assert_equal 4, replace_placements_count(2, 2)
    assert_equal 27, replace_placements_count(3, 3)
    assert_equal 100, replace_placements_count(10, 2)
  end

  def test_combinations_count
    assert_raise(ArgumentError) {combinations_count(0, 3)}
    assert_equal 1, combinations_count(1, 1)
    assert_equal 2, combinations_count(2, 1)
    assert_equal 3, combinations_count(3, 2)
    assert_equal 28, combinations_count(8, 2)
    assert_equal 120, combinations_count(10, 3)
  end

  def test_replace_combinations_count
    assert_raise(ArgumentError) {replace_combinations_count(0, 3)}
    assert_equal 1, replace_combinations_count(1, 1)
    assert_equal 2, replace_combinations_count(2, 1)
    assert_equal 6, replace_combinations_count(3, 2)
    assert_equal 36, replace_combinations_count(8, 2)
    assert_equal 220, replace_combinations_count(10, 3)
  end

  # API classes

  # Permutations
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

  def test_diffrenet_constructor_argimnet_types
    obj = Permutations.new [1, 2]
    assert_equal([[1, 2],
                  [2, 1]], obj.to_a)

    obj = Permutations.new 'ab'
    assert_equal([['a', 'b'],
                  ['b', 'a']], obj.to_a)
    
    obj = Permutations.new 2
    assert_equal([[1, 2],
                  [2, 1]], obj.to_a)

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

  # Placements
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

  # Combinations
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

  # Cartesian product
  def test_cartesian_product_work
    obj = CartesianProduct.new '1234', [1, 2, 3], ['12', 13]
    assert_equal(24, obj.count)
    assert_equal(6, obj.count {|p| p[0] == '1'})

    obj = CartesianProduct.new '123', ['12', 13]
    assert_equal([['1', '12'], ['1', 13], ['2', '12'],
                  ['2', 13], ['3', '12'], ['3', 13], ], obj.to_a)
  end

  # Powerset
  def test_powerset_work
    obj = Powerset.new((1..6).to_a)
    assert_equal(64, obj.count)
    assert_equal(32, obj.count {|p| p.include? 1})

    obj = Powerset.new [1, 2, 3]
    assert_equal([[],
                  [1], [2], [2, 1],
                  [3], [3, 1], [3, 2], 
                  [3, 2, 1]], obj.to_a)
  end

  # Edge cases
  def test_if_empty_src_iter
    assert_equal([], Permutations.new([]).to_a)
    assert_raise(ArgumentError) {Placements.new([], 2)}
    assert_equal([], Placements.new([], 0).to_a)
    assert_equal([], ReplacePlacements.new([], 2).to_a)
    assert_raise(ArgumentError) {Combinations.new([], 2)}
    assert_equal([], Combinations.new([], 0).to_a)
    assert_equal([], ReplaceCombinations.new([], 3).to_a)
    assert_equal([], CartesianProduct.new().to_a)
    assert_equal([], CartesianProduct.new([1, 2], [], [1, 2]).to_a)
    assert_equal([], Powerset.new([]).to_a)
  end

  def test_if_src_iter_is_of_size_one
    assert_equal([[1]], Permutations.new([1]).to_a)
    assert_raise(ArgumentError) {Placements.new([1], 2)}
    assert_equal([[1]], Placements.new([1], 1).to_a)
    assert_equal([[1]], ReplacePlacements.new([1], 1).to_a)
    assert_equal([[1, 1]], ReplacePlacements.new([1], 2).to_a)
    assert_raise(ArgumentError) {Combinations.new([1], 2)}
    assert_equal([[1]], Combinations.new([1], 1).to_a)
    assert_equal([[1]], ReplaceCombinations.new([1], 1).to_a)
    assert_equal([[1, 1, 1]], ReplaceCombinations.new([1], 3).to_a)
    assert_equal([[1]], CartesianProduct.new([1]).to_a)
    assert_equal([[1, 2, 3]], CartesianProduct.new([1], [2], [3]).to_a)
    assert_equal([[], [1]], Powerset.new([1]).to_a)
  end

  def test_if_bad_numbers
    assert_equal([], Placements.new([1, 2, 3], 0).to_a)
    assert_raise(ArgumentError) {Placements.new([1, 2, 3], -1)}
    assert_raise(ArgumentError) {Placements.new([1, 2, 3], 4)}
    assert_equal([], ReplacePlacements.new([1, 2, 3], 0).to_a)
    assert_raise(ArgumentError) {ReplacePlacements.new([1, 2, 3], -1)}
    assert_equal([], Combinations.new([1, 2, 3], 0).to_a)
    assert_raise(ArgumentError) {Combinations.new([1, 2, 3], -1)}
    assert_raise(ArgumentError) {Combinations.new([1, 2, 3], 4)}
    assert_equal([], ReplaceCombinations.new([1, 2, 3], 0).to_a)
    assert_raise(ArgumentError) {ReplaceCombinations.new([1, 2, 3], -1)}
  end

  # Higher order enumerators

  BaseEnumerator = EnumTools::BaseEnumerator

  # Map
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

  # Filter
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

  # Enumerators chain
  def test_filter_and_map_chain
    obj = Combinations.new((1..5).to_a, 3)

    map_filter_obj = obj.map {|arr| arr.reduce(:*)}.filter {|num| num % 15 == 0}
    assert_equal([15, 30, 60], map_filter_obj.to_a)

    filter_map_obj = obj.filter {|arr| arr.reduce(:*) % 15 == 0}.map {|arr| arr.reduce(:+)}
    assert_equal([9, 10, 12], filter_map_obj.to_a)

  end

  def test_take_while_iterator
    obj = ReplacePlacements.new(3, 3).take_while {|arr| arr[0] == 1}

    # TakeWhile is Enumerator, not Array
    assert obj.is_a? BaseEnumerator
    assert_raise(NoMethodError) { obj[0] }

    # to_a method
    assert_equal([[1, 1, 1], [1, 1, 2], [1, 1, 3],
                  [1, 2, 1], [1, 2, 2], [1, 2, 3],
                  [1, 3, 1], [1, 3, 2], [1, 3, 3]], obj.to_a)

    # count method
    assert_equal(9, obj.count)
    assert_equal(6, obj.count {|arr| arr[1] % 2 == 1})

    # can be chained with any iterators
    one_more_obj = obj.filter {|arr| arr[1] >= arr[2]}
    assert_equal(6, one_more_obj.count)

    one_more_obj = obj.map {|arr| arr.zip([100, 10, 1]).map {|v1, v2| v1 * v2}.reduce :+}
    assert_equal([111, 112, 113, 121, 122, 123, 131, 132, 133], one_more_obj.to_a)
    
    # even longer chain
    one_more_obj = obj\
                      .filter {|arr| arr[1] >= arr[2]}\
                      .map {|arr| arr.zip([100, 10, 1]).map {|v1, v2| v1 * v2}.reduce :+}
    assert_equal([111, 121, 122, 131, 132, 133], one_more_obj.to_a)

  end

  def test_drop_while_iterator
    obj = ReplacePlacements.new(3, 3).drop_while {|arr| arr[0] < 3}

    # DropWhile is Enumerator, not Array
    assert obj.is_a? BaseEnumerator
    assert_raise(NoMethodError) { obj[0] }

    # to_a method
    assert_equal([[3, 1, 1], [3, 1, 2], [3, 1, 3],
                  [3, 2, 1], [3, 2, 2], [3, 2, 3],
                  [3, 3, 1], [3, 3, 2], [3, 3, 3]], obj.to_a)

    # count method
    assert_equal(9, obj.count)
    assert_equal(6, obj.count {|arr| arr[1] % 2 == 1})

    # can be chained with any iterators
    one_more_obj = obj.filter {|arr| arr[1] >= arr[2]}
    assert_equal(6, one_more_obj.count)

    one_more_obj = obj.map {|arr| arr.zip([100, 10, 1]).map {|v1, v2| v1 * v2}.reduce :+}
    assert_equal([311, 312, 313, 321, 322, 323, 331, 332, 333], one_more_obj.to_a)
    
    # even longer chain
    one_more_obj = obj\
                      .filter {|arr| arr[1] >= arr[2]}\
                      .map {|arr| arr.zip([100, 10, 1]).map {|v1, v2| v1 * v2}.reduce :+}
    assert_equal([311, 321, 322, 331, 332, 333], one_more_obj.to_a)

  end

  def test_take_plus_drop
    obj = ReplacePlacements.new(3, 3)\
      .drop_while {|arr| arr[0] == 1}
      .take_while {|arr| arr[1] == 1}
    assert_equal([[2, 1, 1], [2, 1, 2], [2, 1, 3]], obj.to_a)

    obj = ReplacePlacements.new(3, 3)\
      .take_while {|arr| arr[0] == 1}
      .drop_while {|arr| arr[1] == 1}
    assert_equal([[1, 2, 1], [1, 2, 2], [1, 2, 3], 
                  [1, 3, 1], [1, 3, 2], [1, 3, 3], ], obj.to_a)

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
