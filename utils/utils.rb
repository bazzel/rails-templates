# Adds a gem entry for the supplied gem to the generated application's Gemfile
# and installs the gems for you.
#
# @example
#  bundle_install do
#    gem 'ember-rails', git: 'https://github.com/emberjs/ember-rails'
#    gem 'ember-source'
#
def bundle_install
  yield

  inside Rails.root do
    Bundler.with_clean_env do
      run 'bundle install'
    end
  end
end

# @return [Pathname] path to `app/assets/javascripts`
def app_js
  Rails.root.join('app', 'assets', 'javascripts')
end

# @return [Pathname] path to `vendor/assets/javascripts`
def vendor_js
  Rails.root.join('vendor', 'assets', 'javascripts')
end
