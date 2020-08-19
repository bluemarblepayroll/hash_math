# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module HashMath
  class Mapper
    # A Lookup instance maintains its own list of objects using its own key extraction method,
    # called 'by' which will be used to extract the key's value for the lookup.
    # If 'by' is a Proc then it will be called when extracting a new lookup record's lookup value.
    # If it is anything other than a Proc and it will call #[] on the object.
    class Lookup
      acts_as_hashable

      attr_reader :name, :by

      def initialize(name:, by:)
        @name    = name
        @by      = by
        @objects = {}

        freeze
      end

      def add_each(array) # :nodoc:
        tap { array.each { |o| add(o) } }
      end

      def add(object) # :nodoc:
        id = proc_or_brackets(object, by)

        objects[id] = object

        self
      end

      def get(value) # :nodoc:
        objects[value]
      end

      private

      attr_reader :objects

      def proc_or_brackets(object, thing)
        return nil unless object

        thing.is_a?(Proc) ? thing.call(object) : object[thing]
      end
    end
  end
end
