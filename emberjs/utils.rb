require "bundler/setup"

module Ember
  class Utils < ::Rails::Generators::Base
    def setup_ember
      copy_ember_js
      inject_ember
      create_dir_layout
      create_app_file
      create_router_file
      create_store_file
      inject_proper_ember_version
    end

    private
    def copy_ember_js
      repo = 'git://github.com/emberjs/'

      copy_js File.expand_path('~/.ember'),
              "#{repo}/ember.js.git",
              'ember.js'
      copy_js File.expand_path('~/.ember-data'),
              "#{repo}/ember-data.js.git",
              'ember-data.js'
    end

    def copy_js(dir, repo, source)
      gem_file = File.join dir, 'Gemfile'
      target = source.gsub(/\./, "-latest.")

      # If it doesn't exist yet
      unless File.exist?(dir)
        command = %{git clone "#{repo}" "#{dir}"}
        say_status('downloading', command, :green)
        cmd command
      else
        Dir.chdir dir do
          command = 'git fetch --force --quiet --tags && git reset origin/master --hard'
          say_status('updating', command, :green)
          cmd command
        end
      end

      Dir.chdir dir do
        say_status('building', "bundle && bundle exec rake", :green)
        Bundler.with_clean_env do
          cmd "bundle --gemfile #{gem_file}"
          cmd %{BUNDLE_GEMFILE="#{gem_file}" bundle exec rake}
        end
      end

      self.class.source_root File.join(dir, "dist")
      copy_file File.join(dir, "dist", source), "vendor/assets/javascripts/#{target}"
    end

    def cmd(command)
      out = `#{command}`

      if $?.exitstatus != 0
        raise "Command error: command `#{command}` in directory #{Dir.pwd} has failed."
      end
      out
    end

    def inject_proper_ember_version
      environment <<-RUBY.strip_heredoc, :env => :development
        config.ember.variant = :development
      RUBY

      environment <<-RUBY.strip_heredoc, :env => :test
        config.ember.variant = :development
      RUBY

      environment <<-RUBY.strip_heredoc, :env => :production
        config.ember.variant = :production
      RUBY
    end


    def inject_ember
      application_file = "app/assets/javascripts/application.js"

      inject_into_file(application_file, :before => "//= require_tree") do
        dependencies = [
          # this should eventually become handlebars-runtime when we remove
          # the runtime dependency on compilation
          "//= require handlebars",
          "//= require ember-latest",
          "//= require ember-data-latest",
          "//= require_self",
          "//= require app",
          "App = Em.Application.create();"
        ]
        dependencies.join("\n").concat("\n")
      end
    end

    def create_dir_layout
      path = "app/assets/javascripts"
      %W{models controllers views routes helpers templates}.each do |dir|
        empty_directory "#{path}/#{dir}"
        create_file "#{path}/#{dir}/.gitkeep"
      end
    end

    def create_app_file
      self.class.source_root File.expand_path('../templates', __FILE__)
      copy_file File.expand_path('../templates/app.js.coffee', __FILE__), "app/assets/javascripts/app.js.coffee"
    end

    def create_router_file
      self.class.source_root File.expand_path('../templates', __FILE__)
      copy_file File.expand_path('../templates/app_router.js.coffee', __FILE__), "app/assets/javascripts/routes/app_router.js.coffee"
    end

    def create_store_file
      self.class.source_root File.expand_path('../templates', __FILE__)
      copy_file File.expand_path('../templates/store.js.coffee', __FILE__), "app/assets/javascripts/store.js.coffee"
    end
  end
end
