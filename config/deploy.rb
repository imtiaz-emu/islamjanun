# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'islamjanun'
set :repo_url, 'git@github.com:imtiaz-emu/islamjanun.git'

set :user, 'imtiaz'
set :use_sudo, false

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app

# Default value for :scm is :git
set :scm, :git

# set :deploy_via, :remote_cache # off while it is first deployment
set :deploy_via, :copy

# Default value for :format is :pretty
# set :format, :pretty
set :rvm1_ruby_version, "ruby-2.1.5"

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle}
set :linked_dirs, fetch(:linked_dirs) + %w{public/system public/uploads}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :pty, true

# Default value for keep_releases is 5
set :keep_releases, 5


# set config unicorn.rb, unicorn_init.sh, nginx.conf file permission after deployment
set :file_permissions_roles, :all
set :file_permissions_users, ['imtiaz']
set :file_permissions_chmod_mode, "0777"


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 1 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
      # execute "sudo service nginx restart"
      # execute "sudo service unicorn restart"
    end

  end

  desc "start solr"
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:start"
  end

  desc "stop solr"
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:stop"
  end

  desc "reindex the whole database"
  task :reindex, :roles => :app do
    stop
    run "rm -rf #{shared_path}/solr/data"
    start
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:reindex"
  end

  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end


  before "deploy:updated", "deploy:set_permissions:chmod"

  after :publishing, :restart
  after :finishing,  :seed
  after :finishing,  :reindex

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end