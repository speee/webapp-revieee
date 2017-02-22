# frozen_string_literal: true
namespace :spotfleet do
  namespace :request do
    desc 'Create spot fleet request'
    task :create do
      client = SpotFleetRequest::Client.new
      client.create
    end
  end
end
