require 'spec_helper'

describe server(:revieee_nginx) do
  describe http(
    'http://sample.reviewapps.speee.jp/sample',
    method: :get,
    headers: { 'HOST' => 'sample.reviewapps.speee.jp' }
  ) do
    it "responds content including 'Hello Sinatra'" do
      expect(response.body).to include('This is test for ngx_mruby hoge')
    end
  end
end
