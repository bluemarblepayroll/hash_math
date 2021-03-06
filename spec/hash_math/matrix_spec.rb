# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe HashMath::Matrix do
  let(:examples) do
    {
      {} => [],
      { a: :b } => [
        { a: :b }
      ],
      { a: 'a1', b: 'b1', c: 'c1' } => [
        { a: 'a1', b: 'b1', c: 'c1' }
      ],
      { a: %w[a1 a2], b: 'b1', c: 'c1' } => [
        { a: 'a1', b: 'b1', c: 'c1' },
        { a: 'a2', b: 'b1', c: 'c1' }
      ],
      { a: %w[a1 a2], b: %w[b1 b2], c: 'c1' } => [
        { a: 'a1', b: 'b1', c: 'c1' },
        { a: 'a1', b: 'b2', c: 'c1' },
        { a: 'a2', b: 'b1', c: 'c1' },
        { a: 'a2', b: 'b2', c: 'c1' }
      ],
      { a: %w[a1 a2], b: %w[b1 b2], c: %w[c1 c2] } => [
        { a: 'a1', b: 'b1', c: 'c1' },
        { a: 'a1', b: 'b1', c: 'c2' },
        { a: 'a1', b: 'b2', c: 'c1' },
        { a: 'a1', b: 'b2', c: 'c2' },

        { a: 'a2', b: 'b1', c: 'c1' },
        { a: 'a2', b: 'b1', c: 'c2' },
        { a: 'a2', b: 'b2', c: 'c1' },
        { a: 'a2', b: 'b2', c: 'c2' }
      ]
    }
  end

  specify '#produce generates correct matrix-expanded hashes' do
    examples.each_pair do |hash, expanded_hashes|
      subject = described_class.new

      hash.each_pair do |k, v|
        v.is_a?(Array) ? subject.add_each(k, v) : subject.add(k, v)
      end

      expect(subject.to_a).to eq(expanded_hashes)
    end
  end
end
