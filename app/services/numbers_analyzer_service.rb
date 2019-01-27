# frozen_string_literal: true

# Analyze arrays for some criteria
class NumbersAnalyzerService
  #  indicates an "outlier" by John Tukey
  K = 1.5.freeze

  def initialize(array)
    @arr = array
  end

  def perform
    { minimum: minimum,
      average: average,
      median: median,
      outlier: outlier }
  end

  private

  attr_reader :arr

  def minimum
    arr.min
  end

  def average
    arr.inject(&:+) / arr.size
  end

  def median
    calculate_median(@arr)
  end

  # see this https://en.wikipedia.org/wiki/Outlier#Tukey's_fences)
  def outlier
    median_array = calculate_median(arr)
    separeted_arrays = arr.each_with_object(array_low: [], array_high: []) do |el, sa|
      sa[:array_low] << el if el <= median_array
      sa[:array_high] << el if el >= median_array
    end
    q1 = calculate_median(separeted_arrays[:array_low])
    q3 = calculate_median(separeted_arrays[:array_high])

    arr.select { |i| i < q1 - K * (q3 - q1) || i > q3 + K * (q3 - q1) }
  end

  def calculate_median(arr)
    size = arr.sort!.size
    if size.even?
      (arr[(size - 1) / 2] + arr[(size + 1) / 2]) / 2
    else
      arr[(size - 1) / 2]
    end
  end
end
