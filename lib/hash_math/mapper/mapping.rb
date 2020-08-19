# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'lookup'

module HashMath
  class Mapper
    # Represents one complete configuration for mapping one key-value pair to one lookup.
    #
    # Example:
    # ----------------------------------------------------------------------------------------------
    # mapping = Mapper.make(
    #   lookup: { name: :patient_statuses, by: :name },
    #   value: :status,
    #   set: :patient_status_id,
    #   with: :id
    # ).add(id: 1, name: 'active').add(id: 2, name: 'inactive')
    #
    # patient        = { id: 1, code: 'active' }
    # mapped_patient = mapping.map!(patient)
    # ----------------------------------------------------------------------------------------------
    #
    # mapped_patient now equals: { id: 1, code: 'active', patient_status_id: 1 }
    class Mapping
      extend Forwardable
      acts_as_hashable

      attr_reader :value, :set, :with, :lookup

      def_delegators :lookup, :name, :by, :add, :add_each

      # lookup: can either be a Mapper#Lookup instance or a hash with the attributes to initialize
      # for a Mapper#Lookup instance.
      # value: the key to use to get the 'value' from the object to lookup.
      # set: the key to set once the lookup record is identified.
      # with: the key use, on the lookup, to get the new value.
      def initialize(lookup:, value:, set:, with:)
        @lookup = Lookup.make(lookup)
        @value  = value
        @set    = set
        @with   = with

        freeze
      end

      def add_each(array) # :nodoc:
        tap { lookup.add_each(array) }
      end

      def add(object) # :nodoc:
        tap { lookup.add(object) }
      end

      def map!(hash) # :nodoc:
        lookup_value  = proc_or_brackets(hash, value)
        lookup_object = lookup.get(lookup_value)
        hash[set]     = proc_or_brackets(lookup_object, with)

        self
      end

      private

      def proc_or_brackets(object, thing)
        return nil unless object

        thing.is_a?(Proc) ? thing.call(object) : object[thing]
      end
    end
  end
end
