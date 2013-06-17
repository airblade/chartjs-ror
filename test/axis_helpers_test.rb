require 'minitest/autorun'
require 'chartjs/axis_helpers'

class AxisHelpersTest < MiniTest::Unit::TestCase

  def setup
    @subject = Object.new
    @subject.extend Chartjs::AxisHelpers
  end

  def test_series_empty_data
    data = {}
    result = @subject.series data
    assert_equal 0, result.length
  end

  def test_series
    data = { 2 => 42 }
    result = @subject.series data
    assert_equal 3, result.length
    assert_equal({0 => 0, 1 => 0, 2 => 42}, result)
  end

  def test_calculate_scale_max
    {
         0 =>    0,
         3 =>    5,
         5 =>    5,
         6 =>   10,
         9 =>   10,
        10 =>   10,
        12 =>   15,
        16 =>   20,
        60 =>   60,
        65 =>   65,
       601 =>  650,
      1430 => 1500,
      7654 => 8000,
    }.each do |input, expected_output|
      assert_equal expected_output, @subject.calculate_scale_max(input)
    end
  end

  def test_ordinate_scale
    data = []
    assert_equal({scaleSteps: 0, scaleStepWidth: 0, scaleStartValue: 0}, @subject.ordinate_scale(data))

    data = [ 12 ]
    assert_equal({scaleSteps: 5, scaleStepWidth: 3, scaleStartValue: 0}, @subject.ordinate_scale(data))

    data = [ 33 ]
    assert_equal({scaleSteps: 7, scaleStepWidth: 5, scaleStartValue: 0}, @subject.ordinate_scale(data))

    data = [ 601 ]
    assert_equal({scaleSteps: 7, scaleStepWidth: 100, scaleStartValue: 0}, @subject.ordinate_scale(data))

    data = [ 999 ]
    assert_equal({scaleSteps: 5, scaleStepWidth: 200, scaleStartValue: 0}, @subject.ordinate_scale(data))

    data = [ 13001 ]
    assert_equal({scaleSteps: 5, scaleStepWidth: 3000, scaleStartValue: 0}, @subject.ordinate_scale(data))
  end

end
