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

    let(:request_body) { JSON.generate({ hoge: :fuga }) }

    before { request.set_header 'HTTP_X_HUB_SIGNATURE', signature }

    context 'with valid signature' do
      let(:signature) { "sha1=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), 'valid_secret', request_body)}" }

      it 'return ok status' do
        get :index, body: request_body
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid signature' do
      let(:signature) { "sha1=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), 'invalid_secret', request_body)}" }

      it 'return unauthorized status' do
        get :index, body: request_body
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
