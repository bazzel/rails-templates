# rails new APP_PATH -m=https://raw.github.com/bazzel/rails-templates/master/ember-simple-auth.rb
# bundle exec rake rails:template LOCATION=https://raw.github.com/bazzel/rails-templates/master/ember-simple-auth.rb
#
# Tested with:
# Rails 4.0.2
# Ember 1.4.0-beta.5
# Ember Data 1.0.0-beta.6
#
# This templates ...:
#  -
#  -
#  -
#
puts
puts '==  Rails template for setting up authentication with Ember.SimpleAuth  ================================'
puts '-- see: http://emberjs.com and http://ember-simple-auth.simplabs.com for more'
puts
puts 'If you haven\'t set up Ember.js in Rails yet, you can do this by running the following template:'
puts
puts '  bundle exec rake rails:template LOCATION=https://raw.github.com/bazzel/rails-templates/master/ember.rb'
puts

# Build and use ember-simple-auth
# (See also https://github.com/simplabs/ember-simple-auth#building):
#
script_name      = 'ember-simple-auth'
script_file_name = "#{script_name}.js"
tmp_folder       = Pathname.new("/tmp/#{script_name}")

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

inject_into_file 'app/assets/javascripts/application.js.coffee', after: "#= require ember\n" do
  "#= require #{script_name}\n"
end

# Enable Ember.SimpleAuth in a custom initializer first:
file 'app/assets/javascripts/initializers/simple_auth.js.coffee', <<-CODE
Ember.Application.initializer
  name: 'authentication',
  initialize: (container, application) ->
    Ember.SimpleAuth.setup(application)
CODE

prepend_file 'app/assets/javascripts/app.js.coffee', <<-CODE
#= require_tree ./initializers
CODE

# then implement the respective mixin in the application route:
file 'app/assets/javascripts/routes/application_route.js.coffee', <<-CODE
App.ApplicationRoute = Ember.Route.extend Ember.SimpleAuth.ApplicationRouteMixin
CODE

prepend_file 'app/assets/javascripts/templates/application.handlebars', <<-CODE

{{#if session.isAuthenticated}}
  <a {{ action 'invalidateSession' }}>Logout</a>
{{else}}
  {{#link-to 'login'}}Login{{/link-to}}
{{/if}}

CODE

inject_into_file 'app/assets/javascripts/router.js.coffee', after: /^App\.Router\.map.*\n/ do
  "  @route 'login'\n"
end

file 'app/assets/javascripts/templates/login.handlebars', <<-CODE
<form {{action 'authenticate' on='submit'}}>
  <label for="identification">Login</label>
  {{input id='identification' placeholder='Enter Login' value=identification}}
  <label for="password">Password</label>
  {{input id='password' placeholder='Enter Password' type='password' value=password}}
  <button type="submit">Login</button>
</form>
CODE
