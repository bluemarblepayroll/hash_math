# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'unpivot/pivot_set'

module HashMath
  # This class has the ability to extrapolate one hash (row) into multiple hashes (rows) while
  # unpivoting specific keys into key-value pairs.
  class Unpivot
    extend Forwardable

    attr_reader :pivot_set

    def_delegators :pivot_set, :add

    def initialize(pivot_set = PivotSet.new)
      @pivot_set = PivotSet.make(pivot_set, nullable: false)

      freeze
    end

    # The main method for this class that performs the un-pivoting and hash expansion.
    # Pass in a hash and it will return an array of hashes.
    def expand(hash)
      return [hash] unless pivot_set.any?

      all_combinations = pivot_set.expand(hash)

      products = all_combinations.inject(all_combinations.shift) do |memo, array|
        memo.product(array)
      end

      recombine(products)
    end

    private

    def recombine(products)
      products.map do |pairs|
        if pairs.is_a?(Array)
          pairs.inject(pairs.shift) { |memo, p| memo.merge(p) }
        else
          pairs
        end
      end
    end
  end
end
