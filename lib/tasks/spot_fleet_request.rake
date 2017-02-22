# frozen_string_literal: true
namespace :spotfleet do
  namespace :request do
    desc 'Create spot fleet request'
    task :create do
      client = SpotFleetRequest::Client.new
      client.create
    end

    desc 'Cancel spot fleet request with spot_fleet_request_id'
    task :cancel, [:spot_fleet_request_id] do |task, args|
      client = SpotFleetRequest::Client.new
      client.cancel(args.spot_fleet_request_id)
    end
  end
end
