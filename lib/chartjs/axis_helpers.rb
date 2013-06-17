require 'active_support'

module Chartjs
  module AxisHelpers

    # Returns an ordered copy of data with "missing" keys mapped to 0 values.
    #
    # data - a Hash of Integer keys mapped to to Integer values.
    #
    # Returns an OrderedHash whose Integer keys run from 0 to data's maximum key
    # and whose values are the corresponding values in data or 0.
    def series(data)
      return {} if data.nil? || data.empty?
      (0..data.keys.max).reduce(ActiveSupport::OrderedHash.new) { |hash,k| hash[k] = data[k] || 0; hash }
    end

    # Calculates the number of steps and the step width for ordinate axis labels.
    # The ordinate axis is assumed to start at 0.
    #
    # data - an Array of Numerics.
    #
    # Returns a Hash with:
    #   :scaleSteps      - the number of steps (always <= 10)
    #   :scaleStepWidth  - the value jump between steps
    #   :scaleStartValue - 0
    def ordinate_scale(data)
      scale_max = calculate_scale_max data.max
      normalised_scale_max = normalise scale_max

      # normalised_scale_max  number_steps  step_width
      #          0                 0           0
      #          0.5               5           1
      #          1                 5           2
      #          1.5               5           3
      #          2                 4           5
      #          2.5               5           5
      #          3                 6           5
      #          3.5               7           5
      #          4                 8           5
      #          4.5               9           5
      #          5                10           5
      #          5.5               6          10
      #          6                 6          10
      #          6.5               7          10
      #          7                 7          10
      #          7.5               8          10
      #          8                 8          10
      #          8.5               9          10
      #          9                 9          10
      #          9.5              10          10
      if normalised_scale_max.zero?
        number_steps = 0
        step_width = 0
      elsif normalised_scale_max < 2
        number_steps = 5
        step_width = scale_max / number_steps
      elsif normalised_scale_max < 5.5
        step_width = 5 * 10**(order_of_magnitude(scale_max) - 1)
        number_steps = scale_max / step_width.to_f
      else
        step_width = 10**(order_of_magnitude(scale_max))
        number_steps = scale_max / step_width.to_f
      end

      {scaleSteps: number_steps.ceil, scaleStepWidth: step_width, scaleStartValue: 0}
    end

    # Rounds up value to the next "increment", where an increment is half
    # the order of magnitude value.
    #
    # value - a Numeric.
    #
    # Examples
    #
    #   input  output
    #     12     15
    #     15     15
    #     16     20
    #   1432   1500
    #   7654   8000
    #
    # Returns an Integer.
    def calculate_scale_max(value)
      normalised = normalise value
      quotient, modulus = normalised.divmod 1
      next_increment = if modulus.zero?
                         quotient
                       elsif modulus <= 0.5
                         quotient + 0.5
                       else
                         quotient + 1
                       end
      (next_increment * 10**(order_of_magnitude(value))).to_i
    end

    # Normalises the value to between 0 inclusive and 10.
    #
    # value - a Numeric.
    #
    # Returns a Float or 0 if value is nil or zero..
    def normalise(value)
      return 0 if value.nil? || value.zero?
      value.to_f / 10**(order_of_magnitude(value))
    end

    # Calculates the order of magnitude of value.
    #
    # value - a Numeric.
    #
    # Examples
    #
    #   order_of_magnitude(3)
    #   # => 1
    #
    #   order_of_magnitude(13)
    #   # => 1
    #
    #   order_of_magnitude(153)
    #   # => 2
    #
    # Returns a Integer or 0 if value is nil or zero.
    def order_of_magnitude(value)
      return 0 if value.nil? || value.zero?
      magnitude = Math.log10 value
      order_of_magnitude = magnitude.floor
      order_of_magnitude.zero? ? 1 : order_of_magnitude
    end

  end
end
