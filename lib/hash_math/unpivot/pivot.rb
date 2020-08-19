# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module HashMath
  class Unpivot
    # A single pivot definition consists of which columns to coalesce and to where.
    class Pivot
      acts_as_hashable

      attr_reader :coalesce_key,
                  :coalesce_key_value,
                  :keys

      # keys is an array of keys to include in the un-pivoting.
      # coalesce_key is the new key to use.
      # coalesce_key_value is the new key to use for its corresponding values.
      def initialize(keys:, coalesce_key:, coalesce_key_value:)
        @keys               = Array(keys)
        @coalesce_key       = coalesce_key
        @coalesce_key_value = coalesce_key_value

        freeze
      end

      # The most rudimentary portion of the Unpivoting algorithm, this method works on
      # just one pivot and returns the extrapolated, un-pivoted rows.
      # Takes two hashes as input:
      # the first will serve as the prototype for each returned hash
      # the second will be one to use for value extraction.
      # Returns an array of hashes.
      def expand(base_hash, value_hash) # :nodoc:
        keys.map do |key|
          base_hash.merge(
            coalesce_key => key,
            coalesce_key_value => value_hash[key]
          )
        end
      end
    end
  end
end
