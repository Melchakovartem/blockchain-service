# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "blockchain"
set :repo_url, "https://github.com/World-WiFi/blockchain_service.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/manage/blockchain"
set :deploy_user, "manage"

# Default value for :linked_files is []
append :linked_files, "config/database.yml", ".env", "config/application.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for keep_releases is 5
set :keep_releases, 5

set :default_shell, '/bin/bash -l'


namespace :deploy do
  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      #Your restart mechanism here
      #execute :touch, release_path.join("tmp/restart.txt")
      invoke "unicorn:restart"
    end
  end

  after :publishing, :restart
end