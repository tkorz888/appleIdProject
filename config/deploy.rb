require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/rvm'    # for rvm support. (http://rvm.io)
#require 'mina/puma'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, '106.75.13.238'
set :deploy_to, '/data/web/app_store_rank'
set :repository, 'git@gitlab.baozou.com:zhangdabei/app_store_rank.git'
set :branch, 'master'
set :puma_config, "/data/web/app_store_rank/shared/config/puma.rb"
# For system-wide RVM install.
set :rvm_use_path, '/usr/local/rvm/bin/rvm'
# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_dirs, ['config/database.yml', 'config/secrets.yml','config/puma.rb', 'log']

# Optional settings:
  set :user, 'root'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.
  set :forward_agent, true     # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use', 'ruby-2.3.1@app_store_rank'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
namespace :puma do 
  task :start => :environment do
    command %[
      if [ -e '/data/web/app_store_rank/shared/tmp/pids/puma.pid' ]; then
        echo 'Puma is already running!';
      else
        if [ -e '/data/web/app_store_rank/shared/config/puma.rb' ]; then
          cd /data/web/app_store_rank/current && bundle exec puma -q -d -e production -C /data/web/app_store_rank/shared/config/puma.rb
        else
          echo 'Puma confi file not found';
        fi
      fi
    ]
  end
  task stop: :environment do
    command %[
      if [ -e '/data/web/app_store_rank/shared/tmp/pids/puma.pid' ]; then
        cd /data/web/app_store_rank/current && bundle exec pumactl -S /data/web/app_store_rank/shared/tmp/sockets/puma.state stop
        rm -f '/data/web/app_store_rank/shared/tmp/sockets/puma.state'
        rm -f '/data/web/app_store_rank/shared/tmp/pids/puma.pid'
      else
        echo 'Puma is not running!';
      fi
    ]
  end
  task phased_restart: :environment do
      command %[
        if [ -e '/data/web/app_store_rank/shared/tmp/pids/puma.pid' ]; then
          cd /data/web/app_store_rank/current && bundle exec pumactl -S /data/web/app_store_rank/shared/tmp/sockets/puma.state --pidfile /data/web/app_store_rank/shared/tmp/pids/puma.pid phased-restart
        else
          echo 'Puma is not running!';
        fi
      ]
  end

end
task :update_crontab => :environment do
  command %[cd /data/web/app_store_rank/current && bundle exec whenever --update-crontab]
end
task :setup => :environment do
  command %[mkdir -p "/data/web/app_store_rank/shared/log"]
  command %[chmod g+rx,u+rwx "/data/web/app_store_rank/shared/log"]

  command %[mkdir -p "/data/web/app_store_rank/shared/config"]
  command %[chmod g+rx,u+rwx "/data/web/app_store_rank/shared/config"]

  command %[touch "/data/web/app_store_rank/shared/config/database.yml"]
  command %[touch "/data/web/app_store_rank/shared/config/secrets.yml"]
  command %[touch "/data/web/app_store_rank/shared/config/puma.rb"]
  
  command  %[echo "-----> Be sure to edit '/data/web/app_store_rank/shared/config/database.yml' and 'secrets.yml'."]

  # Puma needs a place to store its pid file and socket file.
  command %(mkdir -p "/data/web/app_store_rank/shared/tmp/sockets")
  command %(chmod g+rx,u+rwx "/data/web/app_store_rank/shared/tmp/sockets")
  command %(mkdir -p "/data/web/app_store_rank/shared/tmp/pids")
  command %(chmod g+rx,u+rwx "/data/web/app_store_rank/shared/tmp/pids")

  command 'rvm --create --ruby-version use ruby-2.3.1@app_store_rank'


  
end
desc "Deploys the current version to the server."
task :deploy => :environment do
  
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'
    invoke :'puma:phased_restart'
    invoke :'update_crontab'
    
  end
end


# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers