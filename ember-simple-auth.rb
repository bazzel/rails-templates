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

