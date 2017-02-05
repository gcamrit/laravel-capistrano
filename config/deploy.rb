# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'myapp'
set :repo_url, 'https://github.com/gcamrit/laravel-capistrano.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, ENV["branch"] || "master"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/myapp'
set :laravel_dotenv_file, '/var/www/.env'
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
    'storage/logs'

namespace :deploy do
    after :updated, "composer:vendor_copy"
    after :updated, "composer:install"
    after :updated, "laravel:fix_permission"
    after :updated, "laravel:configure_dot_env"    
  #  after :finished, "myapp:create_ver_txt"
end

