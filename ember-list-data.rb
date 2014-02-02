# rails new APP_PATH -m=https://raw.github.com/bazzel/rails-templates/master/ember-list-data.rb
# bundle exec rake rails:template LOCATION=https://raw.github.com/bazzel/rails-templates/master/ember-list-data.rb
#
# Tested with:
# Rails 4.0.2
# Ember 1.4.0-beta.5
# Ember Data 1.0.0-beta.6
#
# This templates asks for a model name and creates:
#  - a Rails model
#  - a Rails controller with an index action
#  - some random data
#  - an Ember route
#  - an Ember template
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

# Collect model name
#
underscored = ask('What\'s the name of model (e.g. `Post` or `post`)?').underscore
pluralized = underscored.pluralize
model_name = underscored.camelize
model_names = model_name.pluralize

attributes = ask("Which attributes does '#{model_name}' have (e.g. `title:string body:text published:boolean`)?").downcase

# Generate resource and replace Rails controller
#
generate :resource, underscored, attributes

run "rm app/controllers/#{pluralized}_controller.rb"
file "app/controllers/#{pluralized}_controller.rb", <<-CODE
class #{model_names}Controller < ApplicationController
  def index
    render json: #{model_name}.all
  end
end
CODE

# Add some fake data
#
# Try to figure out what fake data to use
parsed_attributes = attributes.split(' ').map do |attr|
  name, type = attr.split(':')

  value = case type
  when 'text'
    'Faker::Lorem.paragraphs.join(\'\\n\')'
  when 'boolean'
    '(rand(2) == 1)'
  else
    'Faker::Lorem.word'
  end

  "#{underscored}.#{name} = #{value}"
end

append_file 'db/seeds.rb', <<-CODE
#{model_name}.destroy_all

100.times do
  #{model_name}.new.tap do |#{underscored}|
    #{parsed_attributes.join("\n    ")}
    #{underscored}.save
  end
end
CODE

rake 'db:migrate'
rake 'db:seed'
#
# End Add some fake data

# Ember stuff
#
# `rails g resource` already provided us with a Ember model
#
# Update the router manually:
inject_into_file 'app/assets/javascripts/router.js.coffee', after: 'App.Router.map ()->' do
  "\n  @resource '#{pluralized}'"
end

# `rails g ember:resource` is not very useful:
file "app/assets/javascripts/routes/#{pluralized}_route.js.coffee", <<-CODE
App.#{model_names}Route = Ember.Route.extend
  model: ->
    @store.find '#{underscored}'
CODE

if ask('Do you need an application template? [yN]').downcase == 'y'
  run 'rm app/assets/javascripts/templates/application.handlebars'
  file 'app/assets/javascripts/templates/application.handlebars', <<-CODE
{{outlet}}
CODE
end

# Generate the template
#
file "app/assets/javascripts/templates/#{pluralized}.handlebars", <<-HTML
<ul>
  {{#each}}
  <li>{{title}}</li>
  {{/each}}
</ul>
HTML
#
# End Ember stuff

puts
puts 'Start your server and navigate to:'
puts "http://localhost:3000##{pluralized}"
puts
