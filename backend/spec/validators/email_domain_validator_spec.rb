# frozen_string_literal: true

require 'rails_helper'

class TestModel
  include ActiveModel::Model
  attr_accessor :email

  validates :email, email_domain: true
end

RSpec.describe EmailDomainValidator, type: :validator do
  describe '#validate_each' do
    let(:record) { TestModel.new }

    context 'when the domain is valid' do
      before do
        allow(Resolv::DNS).to receive(:open).and_return([instance_double(Resolv::DNS::Resource::IN::MX)])
      end

      it 'does not add an error to the record' do
        record.email = 'test@example.com'
        record.valid?
        expect(record.errors).not_to have_key(:email)
      end
    end

    context 'when the domain is invalid' do
      before do
        allow(Resolv::DNS).to receive(:open).and_return([])
      end

      it 'adds an error to the record' do
        record.email = 'test@example.com'
        record.valid?
        expect(record.errors[:email]).to include('is not a valid or active domain')
      end
    end
  end
end
