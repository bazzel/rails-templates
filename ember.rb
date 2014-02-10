Dir[File.join(File.dirname(__FILE__), 'utils/*.rb')].each {|file| require file }

# rails new APP_PATH -m=https://raw.github.com/bazzel/rails-templates/master/ember.rb
# bundle exec rake rails:template LOCATION=https://raw.github.com/bazzel/rails-templates/master/ember.rb
#
# Tested with:
# Rails 4.0.2
# Ember 1.4.0-beta.5
# Ember Data 1.0.0-beta.6
#
puts <<-CODE

==  Rails template for setting up Ember.js ================================
-- see: http://emberjs.com/ and https://github.com/emberjs/ember-rails for more

If you haven\'t set up Ember.js in Rails yet, you can do this by running the following template:

  bundle exec rake rails:template LOCATION=https://raw.github.com/bazzel/rails-templates/master/ember.rb

CODE

unless app_js.join('application.js.coffee').exist?
  file app_js.join('application.js.coffee'), <<-CODE.gsub(/^\s*/, '')
    #= require jquery
    #= require jquery_ujs
    #= require_tree .
  CODE
end
remove_file app_js.join('application.js')

# Declare and install gems
#
bundle_install do
  gem 'ember-rails', git: 'https://github.com/emberjs/ember-rails' # Current tag (0.14.1) does not use ActiveModelAdapter yet.
  gem 'ember-source'
end
#
# End Declare and install gems


environment 'config.ember.app_name = \'App\''
environment 'config.ember.variant = :development'
environment 'config.ember.variant = :production', env: 'production'

generate 'ember:bootstrap'

prepend_file app_js.join('app.js.coffee'), <<-CODE
#= require_tree ./initializers
#= require_tree ./mixins
CODE

# Create `initializers` folder
initializers_folder = app_js.join('initializers')
initializers_folder.directory? || initializers_folder.mkpath

# Updating Ember
#
CHANNELS = {
  c: 'canary',
  b: 'beta'
}

begin
  channel = ask('Which release channel do you want to use? (enter "h" for help) [Rbch]').downcase.to_sym

  if channel == :h
    puts <<-HELP

R: release - This references the 'stable' branch, and is recommended for production use.
b: beta    - This references the 'beta' branch, and will ultimately become the next stable version.
             It is not recommended for production use.
c: canary  - This references the 'master' branch and is not recommended for production use.
h: help    - Show this help

See https://github.com/emberjs/ember-rails#updating-ember for more options.


    HELP
  end
end while channel == :h

if CHANNELS.keys.include?(channel)
  channel = CHANNELS[channel.to_sym]
  generate "ember:install --channel=#{channel}"
end
#
# End Updating Ember

# Configure the app to serve Ember.js and app assets from an AssetsController
generate :controller, 'Assets', 'index'

run 'rm app/views/assets/index.html.erb'
file 'app/views/assets/index.html.erb', <<-CODE
<!DOCTYPE html>
<html>
<head>
  <title>Title</title>
  <%= stylesheet_link_tag 'application', :media => 'all' %>
  <%= csrf_meta_tags %>
</head>
<body>
  <%= javascript_include_tag 'application' %>
</body>
</html>
CODE

file app_js.join('templates/application.handlebars'), <<-CODE
<div style='width: 600px; border: 6px solid #eee; margin: 0 auto; padding: 20px; text-align: center; font-family: sans-serif;'>
  <img src='http://emberjs.com/images/about/ember-productivity-sm.png' style='display: block; margin: 0 auto;'>
  <h1>Welcome to Ember.js!</h1>
  <p>You're running an Ember.js app on top of Ruby on Rails. To get started, replace this content
  (inside <code>app/assets/javascripts/templates/application.handlebars</code>) with your application's
  HTML.</p>
</div>
CODE

run 'rm -rf app/views/layouts'
route 'root :to => \'assets#index\''
