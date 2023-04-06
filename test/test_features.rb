require_relative '../lib/probabilityTheory/features'
require 'test/unit'

include Features

class TestProductComplex < Test::Unit::TestCase
  def test_expected_value
    assert_raise(ArgumentError) { expected_value(nil) }
    assert_equal(0,  expected_value([]))
    assert_raise(ArgumentError) { expected_value([1]) }
    assert_raise(ArgumentError) { expected_value([[1, 2], [3]]) }
    assert_equal(2.5, expected_value([[1, 0.25], [2, 0.5], [5, 0.25]]))
  end

  def test_variance
    assert_raise(ArgumentError) { variance(nil) }
    assert_equal(0,  variance([]))
    assert_raise(ArgumentError) { variance([[1, 2], [3]]) }
    assert_equal(2.25, variance([[1, 0.25], [2, 0.5], [5, 0.25]]))
  end

  def test_create_cdf
    assert_raise(ArgumentError) { create_cdf(nil) }
    assert_raise(ArgumentError) { create_cdf([]) }
    assert_equal([[1, 0.25], [2, 0.75], [5, 1.0]], create_cdf([[1, 0.25], [2, 0.5], [5, 0.25]]))
    assert_raise(ArgumentError) { create_cdf([[1, 0.25], [2, -1], [5, 0.25]]) }
    assert_raise(ArgumentError) { create_cdf([[1, 0.25], [2, 1.5], [5, 0.25]]) }
  end

  def test_covariance
    assert_in_delta(2.67, covariance([1, 2, 3, 4], [3, 5, 6, 8]), 0.01)
    assert_in_delta(-2.67, covariance([1, 2, 3, 4], [8, 6, 5, 3]), 0.01)
    assert_raises(ArgumentError) { covariance([1, 2, 3], [4, 5]) }
    assert_raises(ArgumentError) { covariance([1, 2, 'a'], [3, 4, 5]) }
  end

  def test_covariance_matrix
    assert_raises(ArgumentError) { covariance_matrix([]) }
    assert_raises(ArgumentError) { covariance_matrix([[1, 2], [3]]) }
    assert_raises(ArgumentError) { covariance_matrix([[1, 2], [3, 'a']]) }

    expected_matrix = [0.5, 0.75, 0.75, 0.75, 1.17, 1.17, 0.75, 1.17, 1.17]
    actual_matrix = covariance_matrix([[1, 2, 3], [3, 5, 6], [4, 6, 7]]).flatten

    expected_matrix.each_with_index do |elem, i|
      assert_in_delta elem, actual_matrix[i], 0.1, "Arrays differ at index #{i}"
    end

  end

  def test_total_probability
    assert_equal(1, total_probability([0.2, 0.3, 0.5], [0.1, 0.3, 0.6]))
    assert_raises(ArgumentError) { total_probability([0.2, 0.3], [0.1, 0.3, 0.6]) }
    assert_raises(ArgumentError) { total_probability([0.2, 0.3, 0.5], [0.1, 0.3, 'a']) }
    assert_raises(ArgumentError) { total_probability([0.2, 0.3, 0.4], [0.1, 0.3, 0.6]) }
  end

  def test_bayes_theorem
    assert_equal(0.09, bayes_theorem(1, [0.2, 0.3, 0.5], [0.1, 0.3, 0.6]))
    assert_equal(0.3, bayes_theorem(2, [0.2, 0.3, 0.5], [0.1, 0.3, 0.6]))
    assert_raises(ArgumentError) { bayes_theorem(1, [0.2, 0.3], [0.1, 0.3, 0.6]) }
    assert_raises(ArgumentError) { bayes_theorem(1, [0.2, 0.3, 0.5], [0.1, 0.3, 'a']) }
    assert_raises(ArgumentError) { bayes_theorem(3, [0.2, 0.3, 0.5], [0.1, 0.3, 0.6]) }
  end

  def test_bernoulli
    assert_in_delta(0.27869184, bernoulli(0.4, 3, 8), 0.0001)
    assert_in_delta(0.24609375, bernoulli(0.5, 5, 10), 0.0001)

    # Check invalid input
    assert_raise(ArgumentError) { bernoulli('a', 2, 10) }
    assert_raise(ArgumentError) { bernoulli(0.5, -1, 10) }
    assert_raise(ArgumentError) { bernoulli(0.5, 2, -1) }
    assert_raise(ArgumentError) { bernoulli(-0.1, 2, 10) }
    assert_raise(ArgumentError) { bernoulli(1.1, 2, 10) }
  end

  def test_local_laplace
    assert_in_delta(0.0041, local_laplace(1400, 2400, 0.6), 0.0001)
    assert_in_delta(0.315396, local_laplace(8, 10, 0.8), 0.0001)

    # Check invalid input
    assert_raise(ArgumentError) { local_laplace(6, -10, 0.5) }
    assert_raise(ArgumentError) { local_laplace(6, 10, -0.1) }
    assert_raise(ArgumentError) { local_laplace(6, 10, 1.1) }
  end

  def test_integral_laplace
    assert_in_delta(0.796, integral_laplace(3.0, 7.0, 10, 0.5), 0.01)
    assert_in_delta(0.5762, integral_laplace(1.0, 3.0, 10, 0.2), 0.01)

    # Check invalid input
    assert_raise(RuntimeError) { integral_laplace(10, 6, 20, 0.25) }
    assert_raise(RuntimeError) { integral_laplace(6, 10, -20, 0.25) }
    assert_raise(RuntimeError) { integral_laplace(6, 10, 20, -0.1) }
    assert_raise(RuntimeError) { integral_laplace(6, 10, 20, 1.1) }
  end

  def test_conditional_probability
    assert_in_delta(0.75, conditional_probability(8, 6, 4), 0.01)
    assert_in_delta(0.3, conditional_probability(10, 3, 2), 0.01)
  end

  def test_product_joint
    assert_in_delta 0.09, product_joint(10, 3, 2), 0.01
    assert_in_delta 0.5625, product_joint(8, 6, 4), 0.01
  end

  def test_product_incompatible
    assert_in_delta 0.06, product_incompatible(10, 3, 2), 0.01
    assert_in_delta 0.375, product_incompatible(8, 6, 4), 0.01
  end

  def test_sum_incompatible
    assert_in_delta 0.5, sum_incompatible(10, 3, 2), 0.01
    assert_in_delta 1.25, sum_incompatible(8, 6, 4), 0.01
  end

  def test_sum_joint
    assert_in_delta 0.44, sum_joint(10, 3, 2)
    assert_in_delta 0.875, sum_joint(8, 6, 4)
  end

end
