# config valid only for current version of Capistrano
lock '3.7.2'

set :application, 'laravel-capistrano'
set :repo_url, 'https://github.com/gcamrit/laravel-capistrano.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, ENV["branch"] || "master"

# Default deploy_to directory is /var/www/laravel-capistrano
set :deploy_to, '/var/www/laravel-capistrano'
set :laravel_dotenv_file, '/var/www/.env'

# Set current time
require 'date'
set :current_time, DateTime.now


# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
append :linked_dirs, 
    'storage/app',
    'storage/framework/cache',
    'storage/framework/sessions',
    'storage/framework/views',
    'storage/framework/testing',
    'storage/logs'


namespace :app do
        
    desc 'Create release ver.txt'
    task :create_ver_txt do
        on roles(:laravel) do
            puts ("--> Copying ver.txt file")
            execute "cp #{release_path}/config/deploy/ver.txt.example #{release_path}/public/ver.txt"
            execute "sed --in-place 's/%date%/#{fetch(:current_time)}/g
                        s/%branch%/#{fetch(:branch)}/g
                        s/%revision%/#{fetch(:current_revision)}/g
                        s/%deployed_by%/#{fetch(:user)}/g' #{release_path}/public/ver.txt"
            execute "find #{release_path}/public -type f -name 'ver.txt' -exec chmod 664 {} \\;"
        end
    end
end

namespace :deploy do
    after :updated, "composer:vendor_copy"
    after :updated, "composer:install"
    after :updated, "laravel:fix_permission"
    after :updated, "laravel:configure_dot_env"    
    after :finished, "app:create_ver_txt"
end

