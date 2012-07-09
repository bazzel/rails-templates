require File.expand_path('../emberjs/utils', __FILE__)

# rails new APP_PATH --template=http://github.com/bazzel/rails-templates/raw/master/emberjs.rb
# bundle exec rake rails:template LOCATION=http://github.com/bazzel/rails-templates/raw/master/emberjs.rb
puts
puts '==  Rails template for setting up ember.js ================================'
puts '-- We use ember-rails gem with a little customization for now to suite my personal needs'
puts '-- see: http://emberjs.com/ and https://github.com/emberjs/ember-rails for more'
puts

gem 'ember-rails', '~> 0.6.0'

run "bundle install"

# The bootstrap from ember-rails gem does not fit my needs
# (generated files are .js i.o. .js.coffee, global namespace is not named 'App',
# used ember files are a bit outdated). Instead we choose a custom installation.
utils = ::Ember::Utils.new
utils.setup_ember
