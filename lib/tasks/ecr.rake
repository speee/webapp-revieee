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

    desc 'Add specified Iam User to Iam Group (rails ecr:user:join_group[user_name, group])'
    task :join_group, [:user_name, :group_name] do |task, args|
      group = Ecr::IamGroup.new(args.group_name)
      user = Ecr::IamUser.new(args.user_name)
      puts user.join(group)
    end
  end

  namespace :repository do
    desc 'Create ECR Repository ( rails ecr:repository:create[name] )'
    task :create, [:name] do |task, args|
      repository = Ecr::Repository.new(args.name)
      puts repository.create
    end
  end
end
