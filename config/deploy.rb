require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
# require 'mina/puma'

set :application_name, 'islamjanun'
set :domain, '184.164.90.50'
set :deploy_to, '/root/apps/islamjanun'
set :repository, 'git@github.com:imtiaz-emu/islamjanun.git'

set :shared_dirs, fetch(:shared_dirs, []).push('log', 'tmp/pids', 'tmp/sockets', 'public/uploads')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml', 'config/puma.rb')
set :user, 'root'

task :environment do
  invoke :'rvm:use', 'ruby-2.1.5@default'
end

task :setup do
  command %[touch "#{fetch(:shared_path)}/config/database.yml"]
  command %[touch "#{fetch(:shared_path)}/config/secrets.yml"]
  command %[touch "#{fetch(:shared_path)}/config/puma.rb"]
  comment "Be sure to edit '#{fetch(:shared_path)}/config/database.yml', 'secrets.yml' and puma.rb."
end

task :deploy do
  deploy do
    comment "Deploying #{fetch(:application_name)} to #{fetch(:domain)}:#{fetch(:deploy_to)}"
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rvm:load_env_vars'
    invoke :'rails:db_migrate'
    command %{#{fetch(:rails)} db:seed}
    command 'rake sunspot:solr:stop'
    command 'rake sunspot:solr:reindex'
    command 'rake sunspot:solr:start'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      invoke :'puma:start'
    end
  end

end