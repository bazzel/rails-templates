# rails new APP_PATH -m=https://raw.github.com/bazzel/rails-templates/master/ember-list-data.rb
# bundle exec rake rails:template LOCATION=https://raw.github.com/bazzel/rails-templates/master/ember-list-data.rb
#
# Tested with:
# Rails 4.0.2
# Ember 1.4.0-beta.5
# Ember Data 1.0.0-beta.6
#
puts
puts '==  Rails template for setting up Ember.js ================================'
puts '-- see: http://emberjs.com/ and https://github.com/emberjs/ember-rails for more'
puts


# Declare and install gems
#
gem 'faker'

inside Rails.root do
  Bundler.with_clean_env do
    run 'bundle install'
  end
end
#
# End Declare and install gems

generate :resource, 'post', 'title:string body:text published:boolean'

run 'rm app/controllers/posts_controller.rb'
file 'app/controllers/posts_controller.rb', <<-CODE
class PostsController < ApplicationController
  def index
    render json: Post.all
  end
end
CODE

append_file 'db/seeds.rb', <<-CODE
Post.destroy_all

100.times do
  Post.new.tap do |post|
    post.title = Faker::Lorem.word
    post.body = Faker::Lorem.paragraphs.join('\n')
    post.published = (rand(2) == 1)
    post.save
  end
end
CODE

rake 'db:migrate'
rake 'db:seed'

# Use generator where possible
#
# `rails g resource` provides us with a Ember model
#
# Update the router manually:
inject_into_file 'app/assets/javascripts/router.js.coffee', after: 'App.Router.map ()->' do
  "\n  @resource 'posts'"
end

# `rails g ember:resource` is not very useful:
file 'app/assets/javascripts/routes/posts_route.js.coffee', <<-CODE
App.PostsRoute = Ember.Route.extend
  model: ->
    @store.find 'post'
CODE

file 'app/assets/javascripts/templates/posts.handlebars', <<-HTML
<ul>
  {{#each}}
  <li>{{title}}</li>
  {{/each}}
</ul>
HTML


