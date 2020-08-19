# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'mapper/mapping'

module HashMath
  # A Mapper instance can hold multiple constant-time object lookups and then is able to map
  # a hash to its corresponding lookup values.  It's main use-case is to fill in missing or
  # update existing key-value pairs with its corresponding relationships.
  class Mapper
    attr_reader :mappings_by_name

    # Accepts an array of Mapping instances of hashes containing the Mapping instance attributes
    # to initialize.
    def initialize(mappings = [])
      mappings          = Mapping.array(mappings)
      @mappings_by_name = pivot_by_name(mappings)

      freeze
    end

    # Add an enumerable list of lookup records to this instance's lookup dataset.
    def add_each(name, objects)
      tap { objects.each { |o| add(name, o) } }
    end

    # Add a lookup record to this instance's lookup dataset.
    def add(name, object)
      tap { mappings_by_name.fetch(name.to_s).add(object) }
    end

    # Returns a new hash with the added/updated key-value pairs.  Note that this only does a
    # shallow copy using Hash#merge.
    def map(hash)
      map!({}.merge(hash || {}))
    end

    # Mutates the inpuuted hash with the added/updated key-value pairs.
    def map!(hash)
      mappings_by_name.values.each_with_object(hash) do |mapping, _memo|
        mapping.map!(hash)
      end
    end

    private

    def pivot_by_name(array)
      array.each_with_object({}) do |object, memo|
        memo[object.name.to_s] = object
      end
    end
  end
end
