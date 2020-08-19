# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe HashMath::Mapper::Mapping do
  let(:active)           { { id: 1, name: 'active' } }
  let(:inactive)         { { id: 2, name: 'inactive' } }
  let(:patient_statuses) { [active, inactive] }

  let(:mapping) do
    {
      lookup: {
        name: :patient_statuses,
        by: :name
      },
      set: :patient_status_id,
      value: :patient_status,
      with: :id
    }
  end

  subject do
    described_class.make(mapping).add_each(patient_statuses)
  end

  let(:omitted) do
    { patient_id: 1 }
  end

  let(:filled) do
    { patient_id: 2, patient_status: 'active' }
  end

  let(:mismatched) do
    { patient_id: 2, patient_status: 'doesnt_exist' }
  end

  context 'when keys are missing' do
    it 'returns hash with nil values' do
      expected = omitted.merge(patient_status_id: nil)

      subject.map!(omitted)

      expect(omitted).to eq(expected)
    end
  end

  context 'when keys are present' do
    it 'returns hash with values' do
      expected = filled.merge(patient_status_id: 1)

      subject.map!(filled)

      expect(filled).to eq(expected)
    end
  end

  context 'when keys are present but values are missing' do
    it 'returns hash with nil values' do
      expected = mismatched.merge(patient_status_id: nil)

      subject.map!(mismatched)

      expect(mismatched).to eq(expected)
    end
  end
end
