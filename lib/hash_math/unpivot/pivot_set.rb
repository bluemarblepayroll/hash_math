# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'pivot'

module HashMath
  class Unpivot
    # A set of pivots for an Unpivot class to perform.
    class PivotSet
      acts_as_hashable
      extend Forwardable

      attr_reader :pivots

      def_delegators :pivots, :any?

      def initialize(pivots: [])
        @pivots = Pivot.array(pivots)
      end

      # Adds another Pivot configuration object to this objects list of pivots.
      # Returns self.
      def add(pivot)
        tap { pivots << Pivot.make(pivot) }
      end

      # An aggregation of Pivot#expand.  This method will iterate over all pivots
      # and expand them all out.
      def expand(hash) # :nodoc:
        base_hash = make_base_hash(hash)

        pivots.map { |pivot| pivot.expand(base_hash, hash) }
      end

      private

      def make_base_hash(hash)
        keys_to_remove = key_set

        hash.reject { |k, _v| keys_to_remove.include?(k) }
      end

      def key_set
        pivots.flat_map(&:keys).to_set
      end
    end
  end
end
