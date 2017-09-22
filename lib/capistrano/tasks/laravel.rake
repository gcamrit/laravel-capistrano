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
            execute :chmod, "-R ug+rwx #{shared_path}/storage/ #{release_path}/bootstrap/cache/"
            execute :chgrp, "-R www-data #{shared_path}/storage/ #{release_path}/bootstrap/cache/"
        end
    end

    task :configure_dot_env do
    dotenv_file = fetch(:laravel_dotenv_file)
    on roles (:laravel) do
      execute :cp, "#{dotenv_file} #{release_path}/.env"
    end
  end

end