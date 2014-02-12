Dir[File.join(File.dirname(__FILE__), 'utils/*.rb')].each {|file| require file }

# rails new APP_PATH -m=https://raw.github.com/bazzel/rails-templates/master/ember-list-view.rb
# bundle exec rake rails:template LOCATION=https://raw.github.com/bazzel/rails-templates/master/ember-list-view.rb
#
# Tested with:
# Rails 4.0.2
# Ember 1.4.0-beta.5
# Ember Data 1.0.0-beta.6
# Ember.ListView which has no versioning at the time of writing.
#
# This template:
#  - sets up Ember.ListView as described on the site
#  - sets up simple authentication as found in RailsCast #250
#  -
#  -
#  -
#
puts <<-CODE

==  Rails template for setting up authentication with Ember.SimpleAuth  ================================
-- see: http://emberjs.com and https://github.com/emberjs/list-view for more info

If you haven\'t set up Ember.js in Rails yet, you can do this by running the following template:

  bundle exec rake rails:template LOCATION=https://raw.github.com/bazzel/rails-templates/master/ember.rb

CODE

script_name      = 'list-view'
script_file_name = "#{script_name}.js"
tmp_folder       = Pathname.new("/tmp/#{script_name}")

# Build and use Ember.Listview
# (See also https://github.com/emberjs/list-view#build-it):
#
run "git clone https://github.com/emberjs/list-view.git #{tmp_folder}"

inside(tmp_folder) do
  Bundler.with_clean_env do
    run 'bundle install'
    run 'bundle exec rake dist' # `rake 'dist'` throws an error...
  end

  copy_file tmp_folder.join('dist', 'modules', script_file_name), vendor_js.join(script_file_name)
end

remove_dir(tmp_folder)
#
# End Build and use Ember.Listview

# Setup Ember
#
inject_into_file app_js.join('application.js.coffee'), after: "#= require ember\n" do
  "#= require #{script_name}\n"
end

# Add required CSS
#
# Not sure where to put this file and require it by application.css[.scss]...
file app_css.join('list-view.css.scss'), <<-CODE
.ember-list-view {
  overflow: auto;
  position: relative;
}
.ember-list-item-view {
  position: absolute;
}
CODE

puts <<-CODE

*********************************************************************
Congratulations! Ember.ListView has been added to your Rails project.

Please navigate to the GitHub page for further instructions.


More Resources:
  * http://emberjs.com/list-view/
  * https://github.com/emberjs/list-view

CODE
