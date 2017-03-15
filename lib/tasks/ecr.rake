namespace :ecr do
  namespace :group do
    desc 'Create Iam Group (rails ecr:group:create[group_name])'
    task :create, [:name] => :environment do |task, args|
      group = Ecr::IamGroup.new(args.name)
      response = group.create
      puts response
    end
  end

  namespace :user do
    desc 'Create Iam User to use ECR (rails ecr:user:create[user_name])'
    task :create, [:name] => :environment do |task, args|
      user = Ecr::IamUser.new(args.name)
      response = []
      response << user.create
      response << user.create_access_key
      puts response
    end
  end
end
