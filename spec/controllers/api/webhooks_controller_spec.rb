require 'rails_helper'

RSpec.describe Api::WebhooksController, type: :controller do
  before do
    settings_github = double('Settings.github', webhook_secret: 'valid_secret')
    allow(Settings).to receive(:github).and_return(settings_github)
  end

  describe '#valid_signature?' do
    controller do
      def index
        head :ok
      end
    end

    subject { get :index, body: request_body }

    before { request.set_header 'HTTP_X_HUB_SIGNATURE', signature }

    let(:request_body) { JSON.generate({ hoge: :fuga }) }
    let(:signature) { "sha1=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, request_body)}" }

    context 'with valid signature' do
      let(:secret) { 'valid_secret' }
      it { is_expected.to have_http_status(:ok) }
    end

    context 'with invalid signature' do
      let(:secret) { 'invalid_secret' }
      it { is_expected.to have_http_status(:unauthorized) }
    end
  end
end
