namespace :ecr do
  namespace :group do
    desc 'Create Iam Group (rails ecr:group:create[group_name])'
    task :create, [:name] => :environment do |task, args|
      group = Ecr::IamGroup.new(args.name)
      response = group.create
      puts response
    end
  end
end
