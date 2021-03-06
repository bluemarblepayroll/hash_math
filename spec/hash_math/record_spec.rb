# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe HashMath::Record do
  let(:base_value) { '*' }

  let(:examples) do
    {
      { a: :b } => { a: :b, c: base_value, 'a' => base_value, 'c' => base_value },
      { c: :d } => { a: base_value, c: :d, 'a' => base_value, 'c' => base_value },
      { 'a' => :b } => { a: base_value, c: base_value, 'a' => :b, 'c' => base_value },
      { 'c' => :d } => { a: base_value, c: base_value, 'a' => base_value, 'c' => :d }
    }
  end

  subject do
    described_class.new(examples.keys.map(&:keys).flatten, base_value)
  end

  describe '#initialize' do
    it 'derives prototype' do
      expected = {
        a: base_value,
        c: base_value,
        'a' => base_value,
        'c' => base_value
      }

      expect(subject.make).to eq(expected)
    end
  end

  describe '#make' do
    it 'generates correct hashes' do
      examples.each_pair do |hash, normalized_hash|
        expect(subject.make(hash)).to eq(normalized_hash)
      end
    end
  end
end
