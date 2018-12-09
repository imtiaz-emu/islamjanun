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
  task :restart, :roles => :app, :except => {:no_release => true} do
    solr.reindex if 'y' == Capistrano::CLI.ui.ask("\n\n Should I reindex all models? (anything but y will cancel)")
    run "touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end

  desc 'create shared data and pid dirs for Solr'
  task :setup_solr_shared_dirs do
    # conf dir is not shared as different versions need different configs
    %w(data pids).each do |path|
      run "mkdir -p #{shared_path}/solr/#{path}"
    end
  end


  desc 'substituses current_path/solr/data and pids with symlinks to the shared dirs'
  task :link_to_solr_shared_dirs do
    %w(solr/data solr/pids).each do |solr_path|
      run "rm -fr #{current_path}/#{solr_path}" #removing might not be necessary with proper .gitignore setup
      run "ln -s #{shared_path}/#{solr_path} #{current_path}/#{solr_path}"
    end
  end

  before "deploy:updated", "deploy:set_permissions:chmod"

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

desc 'Runs rake db:seed'
task :seed => [:set_rails_env] do
  on primary fetch(:migration_role) do
    within release_path do
      with rails_env: fetch(:rails_env) do
        execute :rake, "db:seed"
      end
    end
  end
end

after 'deploy:setup', 'deploy:setup_solr_shared_dirs'
# rm and symlinks every time we finished uploading code and symlinking to the new release
after 'deploy:update', 'deploy:link_to_solr_shared_dirs'


# Tasks to interact with Solr and SunSpot
namespace :solr do
  desc "start solr"
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:start"
  end
  desc "stop solr"
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:stop"
  end

  desc "stop solr, remove data, start solr, reindex all records"
  task :hard_reindex, :roles => :app do
    stop
    run "rm -rf #{shared_path}/solr/data/*"
    start
    reindex
  end


  desc "simple reindex" #note the yes | reindex to avoid the nil.chomp error
  task :reindex, roles: :app do
    run "cd #{current_path} && yes | RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:reindex"
  end
end