Dir[File.join(File.dirname(__FILE__), 'utils/*.rb')].each {|file| require file }

# rails new APP_PATH -m=https://raw.github.com/bazzel/rails-templates/master/ember-simple-auth.rb
# bundle exec rake rails:template LOCATION=https://raw.github.com/bazzel/rails-templates/master/ember-simple-auth.rb
#
# Tested with:
# Rails 4.0.2
# Ember 1.4.0-beta.5
# Ember Data 1.0.0-beta.6
# Ember SimpleAuth 0.1.1
#
# This template:
#  - sets up Ember SimpleAuth as described on the site
#  - sets up simple authentication as found in RailsCast #250
#  -
#  -
#  -
#
puts <<-CODE

==  Rails template for setting up authentication with Ember.SimpleAuth  ================================
-- see: http://emberjs.com and http://ember-simple-auth.simplabs.com for more info

If you haven\'t set up Ember.js in Rails yet, you can do this by running the following template:

  bundle exec rake rails:template LOCATION=https://raw.github.com/bazzel/rails-templates/master/ember.rb

CODE

# Declare and install gems
#
bundle_install do
  gem 'bcrypt-ruby', '~> 3.1.2'
end
#
# End Declare and install gems

script_name      = 'ember-simple-auth'
script_file_name = "#{script_name}.js"
tmp_folder       = Pathname.new("/tmp/#{script_name}")
app_js = Rails.root.join('app', 'assets', 'javascripts')

# Sample user credentials:
username = 'ember'
password = 'password'

# Build and use ember-simple-auth
# (See also https://github.com/simplabs/ember-simple-auth#building):
#
run "git clone https://github.com/simplabs/ember-simple-auth.git #{tmp_folder}"

inside(tmp_folder) do
  Bundler.with_clean_env do
    run 'bundle install'
    run 'bundle exec rake dist' # `rake 'dist'` throws an error...
  end

  copy_file tmp_folder.join('dist', script_file_name), Rails.root.join('vendor', 'assets', 'javascripts', script_file_name)
end

remove_dir(tmp_folder)
#
# End Build and use ember-simple-auth

# Setup Ember
#
inject_into_file app_js.join('application.js.coffee'), after: "#= require ember\n" do
  "#= require #{script_name}\n"
end

# Enable Ember.SimpleAuth in a custom initializer first:
file app_js.join('initializers/simple_auth.js.coffee'), <<-CODE
Ember.Application.initializer
  name: 'authentication',
  initialize: (container, application) ->
    Ember.SimpleAuth.setup(application)
CODE

prepend_file app_js.join('app.js.coffee'), <<-CODE
#= require_tree ./initializers
CODE

# then implement the respective mixin in the application route:
file app_js.join('routes/application_route.js.coffee'), <<-CODE
App.ApplicationRoute = Ember.Route.extend Ember.SimpleAuth.ApplicationRouteMixin
CODE

# Render login/logout buttons in the template:
prepend_file app_js.join('templates/application.handlebars'), <<-CODE

{{#if session.isAuthenticated}}
  <a {{ action 'invalidateSession' }}>Logout</a>
{{else}}
  {{#link-to 'login'}}Login{{/link-to}}
{{/if}}

CODE

# Setup the route for the login form...
inject_into_file app_js.join('router.js.coffee'), after: /^App\.Router\.map.*\n/ do
  "  @route 'login'\n"
end

# ...and implement the Ember.SimpleAuth mixin in the login controller:
file app_js.join('routes/login_route.js.coffee'), <<-CODE
App.LoginController = Ember.Controller.extend Ember.SimpleAuth.LoginControllerMixin
CODE

# Render the login form:
file app_js.join('templates/login.handlebars'), <<-CODE
<form {{action 'authenticate' on='submit'}}>
  <label for="identification">Login</label>
  {{input id='identification' placeholder='Enter Login' value=identification}}
  <label for="password">Password</label>
  {{input id='password' placeholder='Enter Password' type='password' value=password}}
  <button type="submit">Login</button>
</form>
CODE
#
# Setup Ember

# Set up Rails
#
# User model
#
generate(:resource, 'user', 'username', 'password_digest', 'token')
run 'rm app/assets/javascripts/models/user.js.coffee'
inject_into_file 'app/models/user.rb', after: "class User < ActiveRecord::Base\n" do
  "  has_secure_password\n"
end

# Add `authenticate` to ApplicationController
#
application_controller = Rails.root.join('app', 'controllers', 'application_controller.rb')
# Do we need a `private` method?
application_controller.each_line do |line|
  next if line =~ /private/

  inject_into_file 'app/controllers/application_controller.rb', before: /^end/ do
    "\nprivate\n"
  end
end

inject_into_file application_controller, after: /^\s*private\s*\n/ do
<<-CODE
  def authenticate
    head :unauthorized and return unless current_user
  end

  def current_user
    @current_user ||= access_token && User.find_by_token(access_token)
  end

  def access_token
    @access_token ||= request.authorization && request.authorization.split(' ').last
  end
CODE
end
#
# End Add `authenticate` to ApplicationController

file 'app/controllers/sessions_controller.rb', <<-CODE
class SessionsController < ApplicationController
  def create
    user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
      user.token = SecureRandom.hex
      user.save!
      render json: { access_token: user.token, token_type: 'bearer' }
    else
      head 401
    end
  end
end
CODE

route 'post :token, to: \'sessions#create\''

append_file 'db/seeds.rb', <<-CODE
User.destroy_all

User.create! username: '#{username}', password: '#{password}', password_confirmation: '#{password}'
CODE

rake 'db:migrate'
rake 'db:seed'

puts <<-CODE

*********************************************************************
Congratulations! Ember.SimpleAuth has been added to your Rails project.

Now you can make routes protected by simply implementing the mixin:

  App.Router.map ->
    @route 'posts'

  App.PostsRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,
    model: ->
      @store.find 'post'

Add the following code to your (Rails) controllers to authenticate the user:

  class ProtectedController < ApplicationController
    before_action :authenticate

    ...
  end

A sample user with username `#{username}` and password `#{password}` was created.

More Resources:
  * http://ember-simple-auth.simplabs.com
  * http://railscasts.com/episodes/250-authentication-from-scratch or
    http://railscasts.com/episodes/250-authentication-from-scratch-revised

CODE
