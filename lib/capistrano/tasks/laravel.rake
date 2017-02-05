namespace :laravel do
    desc "Run Laravel Artisan migrate task."
    task :migrate do
        on roles(:laravel) do
            within release_path do
                execute :php, "artisan migrate --force"
            end
        end
    end

    desc "Run Laravel Artisan seed task."
    task :seed do
        on roles(:laravel) do
            within release_path do
            execute :php, "artisan db:seed --force"
            end
        end
    end

    desc "Optimize Laravel Class Loader"
    task :optimize do
        on roles(:laravel) do
            within release_path do
                execute :php, "artisan clear-compiled"
                execute :php, "artisan optimize"
            end
        end
    end

    desc 'Create ver.txt'
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

    task :set_variables do
        on roles(:laravel) do
              puts ("--> Copying environment configuration file")
              execute "cp #{release_path}/.env.server #{release_path}/.env"
              puts ("--> Setting environment variables")
              execute "sed --in-place -f #{fetch(:overlay_path)}/parameters.sed #{release_path}/.env"
        end
    end
    task :fix_permission do
        on roles(:laravel) do
            execute :chmod, "-R 777 #{shared_path}/storage/"
            execute :chmod, "-R 777 #{release_path}/bootstrap/cache/"

        end
    end

    task :configure_dot_env do
    dotenv_file = fetch(:laravel_dotenv_file)
    on roles (:laravel) do
      execute :cp, "#{dotenv_file} #{release_path}/.env"
    end
  end

end