Dir[File.join(File.dirname(__FILE__), 'utils/*.rb')].each {|file| require file }

# rails new APP_PATH -m=https://raw.github.com/bazzel/rails-templates/master/ember-foundation.rb
# bundle exec rake rails:template LOCATION=https://raw.github.com/bazzel/rails-templates/master/ember-foundation.rb
#
# Tested with:
# Rails 4.0.2
# foundation-rails 5.1.1.0
#
# This template sets up Zurb Foundation.
#
puts <<-CODE

==  Rails template for setting up ZURB Foundation  ================================
-- see: http://foundation.zurb.com for more info

CODE

# Declare and install gems
#
bundle_install do
  gem 'foundation-rails', '~> 5.1.1.0'
  gem 'modernizr'
end
#
# End Declare and install gems

generate 'foundation:install'

# Replace JS initialization with CS
gsub_file app_js.join('application.js.coffee'), /.*foundation\(\).*/, '$ -> $(document).foundation()'
prepend_file app_js.join('application.js.coffee'), "#= require modernizr\n"

if ask('Do you need an application layout file? You might not it one if you\'re working on a single-page app? [Yn]').downcase == 'n'
  remove_dir 'app/views/layouts'
end
