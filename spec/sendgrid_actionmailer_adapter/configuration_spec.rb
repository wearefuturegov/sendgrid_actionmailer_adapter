# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SendGridActionMailerAdapter::Configuration do
  let(:api_key) { 'api_key' }
  let(:host) { 'host' }
  let(:request_headers) { { key: 'val' } }
  let(:version) { 'v3' }
  let(:retry_max_count) { 1 }
  let(:retry_wait_seconds) { 0.5 }
  let(:return_response) { true }

  before do
    SendGridActionMailerAdapter.configure do |config|
      config.api_key = api_key
      config.host = host
      config.request_headers = request_headers
      config.version = version
      config.retry_max_count = retry_max_count
      config.retry_wait_seconds = retry_wait_seconds
      config.return_response = return_response
      config.asm = ::SendGrid::ASM.new(group_id: 99, groups_to_display: [4, 5, 6, 7, 8])
    end
  end

  after do
    SendGridActionMailerAdapter::Configuration.reset!
  end

  describe '.settings' do
    subject { SendGridActionMailerAdapter::Configuration.settings }

    let(:expected) do
      {
        sendgrid: {
          api_key: api_key,
          host: host,
          request_headers: request_headers,
          version: version,
        },
        retry: {
          max_count: retry_max_count,
          wait_seconds: retry_wait_seconds,
        },
        return_response: return_response,
      }
    end

    it { is_expected.to eq(expected) }
  end

  describe '.asm' do
    subject { SendGridActionMailerAdapter::Configuration.asm }

    let(:expected) do
      ::SendGrid::ASM.new(group_id: 99, groups_to_display: [4, 5, 6, 7, 8])
    end

    it { is_expected.to be_a(::SendGrid::ASM) }

    it 'sets the right group id' do
      expect(expected.group_id).to eq(99)
    end

    it 'sets the right groups to display' do
      expect(expected.groups_to_display).to eq([4, 5, 6, 7, 8])
    end
  end
end
