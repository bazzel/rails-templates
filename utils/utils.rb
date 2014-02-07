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
