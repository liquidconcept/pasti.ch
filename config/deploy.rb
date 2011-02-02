# encoding: utf-8
set :application, 'website'
set :domain,      'pasti.ch'
set :server_name, 'pasti.ch'

set :scm,         :git
set :repository,  'git@github.com:liquidconcept/pasti.ch.git'
set :branch,      'master'

ssh_options[:forward_agent] = true

default_run_options[:pty] = true
default_environment['LC_CTYPE'] = 'en_US.UTF-8'

set :user,        'webpublisher'
set :deploy_via,  :remote_cache
set :deploy_to,   "/var/www/#{domain}/#{application}"
set :use_sudo,    false

role :web, server_name                          # Your HTTP server, Apache/etc
role :app, server_name                          # This may be the same as your `Web` server
role :db,  server_name, :primary => true        # This is where Rails migrations will run

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

before 'deploy:symlink' do
  # run "mkdir -p #{File.join(shared_path,'sqlite')} && rm -f #{File.join(release_path,'db','.gitkeep')} && rmdir #{File.join(release_path,'db')} && ln -s #{File.join(shared_path,'sqlite')} #{File.join(release_path,'db')}"
  run "cd #{release_path} && RACK_ENV=\"production\" bundle exec nanoc3 compile > /dev/null"
end
before 'deploy:symlink', 'jammit:invoke'

after 'deploy:update', 'deploy:restart'
after 'deploy:update', 'deploy:cleanup'

namespace :jammit do
  desc "Run jammit on server"
  task :invoke do
    bundle = fetch(:bundle, "bundle")
    jammit = fetch(:jammit, "jammit")
    rails_env = fetch(:rails_env, "production")
    run("cd #{latest_release}; RACK_ENV=#{rails_env} #{bundle} exec #{jammit}")
  end
end
