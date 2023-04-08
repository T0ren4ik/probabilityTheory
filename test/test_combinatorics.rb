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

  def test_replace_perms_also_work
    obj = Permutations.new '1121'
    assert_equal(4, obj.count)
    assert_equal(2, obj.count {|perm| perm[0] == perm[1]})
    assert_equal([['1', '1', '1', '2'],
                  ['1', '1', '2', '1'],
                  ['1', '2', '1', '1'], 
                  ['2', '1', '1', '1'],], obj.to_a)
  end

  def test_covariance
    # assert_in_delta(2.67, covariance([1, 2, 3, 4], [3, 5, 6, 8]), 0.01)
    # assert_in_delta(-2.67, covariance([1, 2, 3, 4], [8, 6, 5, 3]), 0.01)
  end

  def test_covariance_matrix

    # expected_matrix = [0.5, 0.75, 0.75, 0.75, 1.17, 1.17, 0.75, 1.17, 1.17]
    # actual_matrix = covariance_matrix([[1, 2, 3], [3, 5, 6], [4, 6, 7]]).flatten

    # expected_matrix.each_with_index do |elem, i|
    #   assert_in_delta elem, actual_matrix[i], 0.1, "Arrays differ at index #{i}"
    # end

  end

  def test_total_probability
    # assert_raises(ArgumentError) { total_probability([0.2, 0.3, 0.4], [0.1, 0.3, 0.6]) }
  end

  def test_bayes_theorem
  end

  def test_bernoulli
  end

  def test_local_laplace
  end

  def test_integral_laplace
  end

  def test_conditional_probability
    # assert_in_delta(0.75, conditional_probability(8, 6, 4), 0.01)
    # assert_in_delta(0.3, conditional_probability(10, 3, 2), 0.01)
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
# enumerator_count_performance_test
