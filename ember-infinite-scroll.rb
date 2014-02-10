Dir[File.join(File.dirname(__FILE__), 'utils/*.rb')].each {|file| require file }
require 'net/http'

# rails new APP_PATH -m=https://raw.github.com/bazzel/rails-templates/master/ember-infinite-scroll.rb
# bundle exec rake rails:template LOCATION=https://raw.github.com/bazzel/rails-templates/master/ember-infinite-scroll.rb
#
# Tested with:
# Rails 4.0.2
# Ember 1.4.0-beta.6
# Ember Data 1.0.0-beta.6
#
# This template:
# * downloads a Gist from GitHub containing a Ember Mixins for extending views and controllers for infinite scrolling
# * installs will_paginate to implement server side pagination
# * prints instructions for how to use infinite scrolling
#
#
puts <<-CODE

==  Rails template for setting up infinite scrolling with Ember.js  ================================
-- see: https://gist.github.com/bazzel/8905925 for more info

CODE

# Declare and install gems
#
bundle_install do
  gem 'will_paginate'
end
#
# End Declare and install gems

# Download mixin
url = 'https://gist.github.com/bazzel/8905925/raw/775c8a5e83fcc44b10a087f646b60d8468cf0d57/ember-infinite-scroll.js.coffee'

app_js.join('mixins', 'ember-infinite-scroll.js.coffee').open('w') do |f|
  f.write Net::HTTP.get(URI(url))
end

puts <<-CODE

*********************************************************************
Congratulations! InfiniteScroll has been added to your Rails project.

Now you can use infinite scroll by simply implementing the mixins:

  App.PostsView = Ember.View.extend InfiniteScroll.ViewMixin,
    ...

  App.PostsController = Ember.ArrayController.extend InfiniteScroll.ControllerMixin,
    ...


Your Rails controller should perform a paginated query and
extend your rendered JSON data with a meta key:

  PostsController < ApplicationController
    def index
      posts = Post.paginate(page: params[:page], per_page: 100)
      render json: posts,
           meta: {
             page: posts.current_page.to_i,
             total_pages: posts.total_pages
           }
    end
  end

To show a loading indicator you can use the `isLoading` property
defined on the controller by the ControllerMixin:

  {{#unless isLoading}}
    <div class='loading'>Loading...</div>
  {{/unless}}


More Resources:
  * https://github.com/mislav/will_paginate

CODE
