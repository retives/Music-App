# frozen_string_literal: true

class EmailDomainValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    domain = value.split('@').last
    mx_records = Resolv::DNS.open do |dns|
      dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
    end

    record.errors.add(attribute, :invalid_domain, message: 'is not a valid or active domain') unless mx_records.any?
  end
end
